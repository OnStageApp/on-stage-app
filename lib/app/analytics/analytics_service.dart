// analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@riverpod
class AnalyticsService extends _$AnalyticsService {
  @override
  void build() {
    return;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() => _analytics.logAppOpen();

  Future<void> logLogin(String method) =>
      _analytics.logLogin(loginMethod: method);

  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  Future<void> logSignUp(String method) =>
      _analytics.logSignUp(signUpMethod: method);

  Future<void> logPurchase({
    required String itemId,
    required double value,
    required String currency,
  }) {
    return _analytics.logPurchase(
      currency: currency,
      value: value,
      items: [AnalyticsEventItem(itemId: itemId)],
    );
  }

  Future<void> logScreenView(String screenName) {
    return _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logCustomEvent(String name, Map<String, Object> parameters) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logUserEngagement({required int engagementTimeMillis}) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {'engagement_time_msec': engagementTimeMillis},
    );
  }
}
