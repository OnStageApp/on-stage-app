// analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:on_stage_app/app/utils/environment_manager.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
class AnalyticsService extends _$AnalyticsService {
  FirebaseAnalytics? _analytics;

  FirebaseAnalytics get analytics {
    _analytics ??= FirebaseAnalytics.instance;
    return _analytics!;
  }

  @override
  void build() {
    _analytics = FirebaseAnalytics.instance;
    if (EnvironmentManager.isProduction) {
      logger.i('Analytics enabled');
      _analytics?.setAnalyticsCollectionEnabled(true);
    } else {
      logger.i('Analytics disabled');
      _analytics?.setAnalyticsCollectionEnabled(false);
    }
    return;
  }

  Future<void> logAppOpen() => analytics.logAppOpen();

  Future<void> logLogin(String method) =>
      analytics.logLogin(loginMethod: method);

  Future<void> setUserId(String userId) async {
    await analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logSignUp(String method) =>
      analytics.logSignUp(signUpMethod: method);

  Future<void> logPurchase({
    required String itemId,
    required double value,
    required String currency,
  }) {
    return analytics.logPurchase(
      currency: currency,
      value: value,
      items: [AnalyticsEventItem(itemId: itemId)],
    );
  }

  Future<void> logScreenView(String screenName) {
    return analytics.logScreenView(screenName: screenName);
  }

  Future<void> logCustomEvent(String name, Map<String, Object> parameters) {
    return analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logUserEngagement({required int engagementTimeMillis}) async {
    await analytics.logEvent(
      name: 'user_engagement',
      parameters: {'engagement_time_msec': engagementTimeMillis},
    );
  }
}
