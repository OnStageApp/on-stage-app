import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart'; // Make sure to add this package to your pubspec.yaml
import 'package:on_stage_app/app/features/plan/domain/plan.dart';
import 'package:on_stage_app/app/features/subscription/application/subscription_state.dart';
import 'package:on_stage_app/app/features/subscription/data/subscription_repository.dart';
import 'package:on_stage_app/app/features/subscription/domain/subscription.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_notifier.g.dart';

@Riverpod(keepAlive: true)
class SubscriptionNotifier extends _$SubscriptionNotifier {
  SubscriptionRepository? _subscriptionRepository;

  SubscriptionRepository get subscriptionRepository {
    _subscriptionRepository ??= SubscriptionRepository(ref.read(dioProvider));
    return _subscriptionRepository!;
  }

  final logger = Logger();

  @override
  SubscriptionState build() {
    logger.d('SubscriptionNotifier: build() called');
    _subscriptionRepository = SubscriptionRepository(ref.read(dioProvider));
    return const SubscriptionState();
  }

  Future<void> init() async {
    logger.d('SubscriptionNotifier: init() started');
    try {
      await Purchases.setLogLevel(LogLevel.verbose);
      logger.d('RevenueCat log level set to verbose');

      PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(
          dotenv.get('REVENUE_CAT_ANDROID_SDK_KEY'),
        );
        logger.d('Using Android configuration');
      } else {
        configuration = PurchasesConfiguration(
          dotenv.get('REVENUE_CAT_IOS_SDK_KEY'),
        );
        logger.d('Using iOS configuration');
      }

      await Purchases.configure(configuration);
      logger.d('RevenueCat configured');

      final customerInfo = await Purchases.getCustomerInfo();
      logger.d(
          'Initial customer info fetched: ${customerInfo.originalAppUserId}');

      state = state.copyWith(customerInfo: customerInfo);
      _updatePremiumStatus();

      await getCurrentSubscription();

      logger.d('SubscriptionNotifier initialization completed');
    } catch (e) {
      logger.e('Failed to initialize RevenueCat: $e');
      state =
          state.copyWith(errorMessage: 'Failed to initialize RevenueCat: $e');
    }
  }

  Future<void> purchasePackage(String packageId) async {
    state = state.copyWith(isLoading: true);

    try {
      final products = await Purchases.getProducts(['onstage_50_1m_1m0']);
      final customInfo = await Purchases.purchaseStoreProduct(products.first);
      state = state.copyWith(
        customerInfo: customInfo,
        isLoading: false,
        errorMessage: null,
      );
      _updatePremiumStatus();
    } catch (e) {
      logger.e('Failed to purchase package: $packageId, error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to purchase package: $e',
      );
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    logger.d('Attempting to restore purchases');
    state = state.copyWith(isLoading: true);

    try {
      final customerInfo = await Purchases.restorePurchases();
      logger.d('Purchases restored: ${customerInfo.originalAppUserId}');
      state = state.copyWith(
        customerInfo: customerInfo,
        isLoading: false,
        errorMessage: null,
      );
      _updatePremiumStatus();
    } catch (e) {
      logger.e('Failed to restore purchases: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to restore purchases: $e',
      );
    }
  }

  Future<void> logout() async {
    logger.d('Logging out user');
    await Purchases.logOut();
    state = state.copyWith(
      customerInfo: null,
      hasPremiumAccess: false,
    );
    logger.d('User logged out');
  }

  void _updatePremiumStatus() {
    //TODO: It will be implemented with BE
  }

  Future<void> getCurrentSubscription() async {
    final subscription = Subscription(
      id: "67140628703b1840a6ace9c7",
      teamId: "670f78a8ded8ce743fd8bf23",
      userId: "qQnN1Zsri6XLyMSScazW0V7Yswx2",
      plan: const Plan(
        id: "670ff1b5e5844c1f35fd6536",
        name: "Solo Monthly",
        maxEvents: 10,
        maxMembers: 1,
        hasSongsAccess: true,
        hasAddSong: false,
        hasScreensSync: false,
        hasReminders: false,
        revenueCatProductId: "onstage_50_1m_1m0",
        price: 49,
        currency: "RON",
        isYearly: false,
      ),
      purchaseDate: DateTime.parse("2024-10-19T19:19:04.020Z"),
      expirationDate: DateTime.parse("2024-11-19T20:23:12.402Z"),
      status: "CANCELLED",
    );
    // final currentSubscription =
    //     await subscriptionRepository.getCurrentSubscription();
    state = state.copyWith(currentSubscription: subscription);
    logger.i('Current subscription set');
  }
}
