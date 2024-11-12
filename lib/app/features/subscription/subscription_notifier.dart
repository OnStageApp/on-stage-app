import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/application/subscription_state.dart';
import 'package:on_stage_app/app/features/subscription/data/subscription_repository.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_notifier.g.dart';

const androidSubscriptionGroup = 'onstage';

@Riverpod(keepAlive: true)
class SubscriptionNotifier extends _$SubscriptionNotifier {
  SubscriptionRepository? _subscriptionRepository;
  AppDatabase? _localDb;

  AppDatabase get db {
    _localDb ??= ref.read(databaseProvider);
    return _localDb!;
  }

  SubscriptionRepository get subscriptionRepository {
    _subscriptionRepository ??= SubscriptionRepository(ref.read(dioProvider));
    return _subscriptionRepository!;
  }

  final logger = Logger();

  @override
  SubscriptionState build() {
    logger.d('SubscriptionNotifier: build() called');
    _subscriptionRepository = SubscriptionRepository(ref.read(dioProvider));
    _localDb = ref.read(databaseProvider);

    _listenForAuthentication();
    return const SubscriptionState();
  }

  void _listenForAuthentication() {
    ref.listen(
      userNotifierProvider.select((state) => state.currentUser),
      (previous, current) async {
        if (previous?.id != current?.id) {
          if (current != null) {
            logger.d(
              'User logged in, syncing subscription for user: ${current.id}',
            );
            await Purchases.logIn(current.id);
          } else {
            //TODO: logout is not working we need to handle this one, is not triggered. I thing provider gets invalidated
            logger.d('User logged out, clearing subscription for user');
            state = const SubscriptionState();
            await Purchases.logOut();
          }
        }
      },
    );
  }

  Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.verbose);

      final customerInfo = await _setConfigurations();

      state = state.copyWith(customerInfo: customerInfo);

      await getCurrentSubscription(forceUpdate: true);
      await saveCurrentPlan();

      logger.d('SubscriptionNotifier initialization completed');
    } catch (e, s) {
      logger.e('Failed to initialize RevenueCat: $e $s');
      state =
          state.copyWith(errorMessage: 'Failed to initialize RevenueCat: $e');
    }
  }

  Future<void> purchasePackage(String packageId) async {
    try {
      final List<StoreProduct> products;
      if (Platform.isAndroid) {
        ///This is a workaround until RevenueCat fix the issue with the subscription group
        final productsGroup = await Purchases.getProducts(
          [androidSubscriptionGroup],
        );
        products = productsGroup
            .where(
              (element) => element.identifier == packageId,
            )
            .toList();
      } else {
        products = await Purchases.getProducts(
          [packageId],
        );
      }

      logger.i('Products fetched: $products');
      state = state.copyWith(isLoading: true);

      final customInfo = await Purchases.purchaseStoreProduct(products.first);

      state = state.copyWith(
        customerInfo: customInfo,
        isLoading: false,
        errorMessage: null,
      );
      logger.i('Package purchased successfully: $packageId');
    } catch (e) {
      // Log the error with detailed info for sandbox vs production handling
      if (e is PurchasesErrorCode &&
          e == PurchasesErrorCode.paymentPendingError) {
        logger.w('Payment pending for package: $packageId');
      } else if (e is PurchasesErrorCode &&
          e == PurchasesErrorCode.invalidReceiptError) {
        logger
            .e('Invalid receipt error: Ensure sandbox and production handling');
        // Add further custom handling here if needed for sandbox receipt validation
      } else {
        logger.e('Failed to purchase package: $packageId, error: $e');
      }

      // Update the state with error information
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to purchase package: $e',
      );
      rethrow;
    }
  }

  Future<void> getCurrentSubscription({
    bool forceUpdate = false,
  }) async {
    logger.d('Getting current subscription');
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true);
    }

    try {
      if (!forceUpdate) {
        final localSubscription = await db.getCurrentSubscription();
        if (localSubscription != null) {
          state = state.copyWith(
            currentSubscription: localSubscription,
            isLoading: false,
          );
          return;
        }
      }

      final backendSubscription =
          await subscriptionRepository.getCurrentSubscription();

      await db.saveSubscription(backendSubscription);
      state = state.copyWith(
        currentSubscription: backendSubscription,
        isLoading: false,
      );
      return;
    } catch (e, s) {
      // Log error and handle sandbox receipt issues if applicable
      if (e.toString().contains('Sandbox receipt used in production')) {
        logger.w(
            'Sandbox receipt encountered in production, switching to sandbox environment $s');
        // Implement specific handling here or retry logic if necessary
      }
      logger.e('Error getting current subscription $e');
      state = state.copyWith(isLoading: false);
      return;
    } finally {
      await saveCurrentPlan();
    }
  }

  Future<void> updateSubscription(Subscription subscription) async {
    try {
      await subscriptionRepository.updateSubscription(subscription);

      await db.saveSubscription(subscription);

      state = state.copyWith(currentSubscription: subscription);
      logger.i('Subscription updated successfully');
    } catch (e) {
      logger.e('Error updating subscription $e');
      await db.saveSubscription(subscription);
      state = state.copyWith(currentSubscription: subscription);
      rethrow;
    }
  }

  Future<Plan?> saveCurrentPlan() async {
    final planId = state.currentSubscription?.planId;
    if (planId == null) return null;
    final currentPlan =
        await ref.read(planServiceProvider.notifier).getPlanById(planId);
    state = state.copyWith(currentPlan: currentPlan);
    return currentPlan;
  }

  Future<CustomerInfo> _setConfigurations() async {
    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(
        dotenv.get('REVENUE_CAT_ANDROID_SDK_KEY'),
      );
    } else {
      configuration = PurchasesConfiguration(
        dotenv.get('REVENUE_CAT_IOS_SDK_KEY'),
      );
    }

    await Purchases.configure(configuration);

    logger.d(
        'Purchases configured using ${Platform.isAndroid ? "Android" : "iOS"} environment');

    final customerInfo = await Purchases.getCustomerInfo();
    logger
        .d('Initial customer info fetched: ${customerInfo.originalAppUserId}');
    return customerInfo;
  }
}

// TODO: We need a way to trigger it for update the localDB, maybe on the websocket, open a new one
//TODO: Handle when data is changed, update db directly i think.. or maybe not, we need to check the data first, if we can update it or not
