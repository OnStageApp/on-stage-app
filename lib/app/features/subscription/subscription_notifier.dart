import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
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
    _subscriptionRepository ??= SubscriptionRepository(ref.watch(dioProvider));
    return _subscriptionRepository!;
  }

  final _logger = Logger();

  @override
  SubscriptionState build() {
    _logger.d('SubscriptionNotifier: build() called');
    _subscriptionRepository = SubscriptionRepository(ref.watch(dioProvider));
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
            _logger.d(
              'User logged in, syncing subscription for user: ${current.id}',
            );
            await Purchases.logIn(current.id);
          } else {
            //TODO: logout is not working we need to handle this one, is not triggered. I thing provider gets invalidated
            _logger.d('User logged out, clearing subscription for user');
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

      _logger.d('SubscriptionNotifier initialization completed');
    } catch (e, s) {
      _logger.e('Failed to initialize RevenueCat: $e $s');
      state =
          state.copyWith(errorMessage: 'Failed to initialize RevenueCat: $e');
    }
  }

  Future<void> purchasePackage(String packageId) async {
    try {
      state = state.copyWith(isLoading: true);

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

      _logger.i('Products fetched: $products');

      final customInfo = await Purchases.purchaseStoreProduct(products.first);

      state = state.copyWith(
        customerInfo: customInfo,
        isLoading: false,
        errorMessage: null,
      );
      _logger.i('Package purchased successfully: $packageId');
    } catch (e) {
      if (e is PurchasesErrorCode &&
          e == PurchasesErrorCode.paymentPendingError) {
        _logger.w('Payment pending for package: $packageId');
      } else if (e is PurchasesErrorCode &&
          e == PurchasesErrorCode.invalidReceiptError) {
        _logger
            .e('Invalid receipt error: Ensure sandbox and production handling');
      } else if (e is PurchasesErrorCode &&
          e == PurchasesErrorCode.purchaseCancelledError) {
        _logger.i('Purchase cancelled for package: $packageId');
      } else if (e is PlatformException && e.code == '1') {
        _logger.i('User cancelled the purchase with package: $packageId');
        state = state.copyWith(
          isLoading: false,
        );
        return;
      } else {
        _logger.e('Failed to purchase package: $packageId, error: $e');
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to purchase package: $e',
      );
    }
  }

  Future<void> getCurrentSubscription({
    bool forceUpdate = false,
  }) async {
    _logger.d('Getting current subscription');
    if (!state.isLoading) {
      state = state.copyWith(isLoading: true);
    }

    try {
      if (!forceUpdate) {
        final localSubscription =
            await ref.read(databaseProvider).getCurrentSubscription();
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

      await ref.read(databaseProvider).saveSubscription(backendSubscription);
      state = state.copyWith(
        currentSubscription: backendSubscription,
        isLoading: false,
      );
      await saveCurrentPlan();
      return;
    } catch (e, s) {
      if (e.toString().contains('Sandbox receipt used in production')) {
        _logger.w(
          'Sandbox receipt encountered in '
          'production, switching to sandbox environment $s',
        );
      }
      _logger.e('Error getting current subscription $e');
      state = state.copyWith(isLoading: false);
      return;
    }
  }

  Future<void> updateSubscription(Subscription subscription) async {
    try {
      await subscriptionRepository.updateSubscription(subscription);

      await ref.read(databaseProvider).saveSubscription(subscription);

      state = state.copyWith(currentSubscription: subscription);
      await saveCurrentPlan();
      _logger.i('Subscription updated successfully');
    } catch (e) {
      _logger.e('Error updating subscription $e');
      await ref.read(databaseProvider).saveSubscription(subscription);
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

  Future<void> restorePurchases() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      _logger.d('Attempting to restore purchases');

      final customerInfo = await Purchases.restorePurchases();

      state = state.copyWith(
        customerInfo: customerInfo,
        isLoading: false,
      );

      await getCurrentSubscription(forceUpdate: true);
      await saveCurrentPlan();

      _logger.i('Purchases restored successfully');
    } catch (e) {
      _logger.e('Failed to restore purchases: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to restore purchases: $e',
      );
    }
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

    _logger.d(
      'Purchases configured '
      'using ${Platform.isAndroid ? "Android" : "iOS"} environment',
    );

    final customerInfo = await Purchases.getCustomerInfo();
    _logger
        .d('Initial customer info fetched: ${customerInfo.originalAppUserId}');
    return customerInfo;
  }
}
