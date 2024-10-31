import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:on_stage_app/app/device/application/device_service.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_notifier.g.dart';

/// Background message handler for Firebase Messaging.
/// This function must be a top-level function to be called by the OS.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.i('Background message: ${message.messageId}');
}

@riverpod
class FirebaseNotifier extends _$FirebaseNotifier {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _pendingRoute;

  @override
  Future<void> build() async {
    await _initialize();
  }

  /// Initializes Firebase Messaging and local notifications.
  Future<void> _initialize() async {
    await _requestPermissions();
    await _setupLocalNotifications();
    await _configurePushToken();
    _configureMessageHandlers();
  }

  /// Requests notification permissions from the user.
  Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  /// Sets up local notifications for both Android and iOS.
  /// Sets up local notifications for both Android and iOS.
  Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) =>
          _handleNotificationResponse(response.payload),
    );

    // Disable automatic notification display by Firebase Messaging
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Configures the push token and handles token refresh.
  Future<void> _configurePushToken() async {
    final pushToken = await FirebaseMessaging.instance.getToken();
    if (pushToken != null) {
      await _updatePushToken(pushToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(_updatePushToken);
  }

  /// Updates the push token on the device service.
  Future<void> _updatePushToken(String pushToken) async {
    logger.i('Updating device token: $pushToken');
    await ref.read(deviceServiceProvider).updatePushToken(pushToken);
  }

  /// Configures message handlers for foreground and background messages.
  void _configureMessageHandlers() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) =>
          _handleNotificationResponse(message.data['screen'] as String?),
    );
  }

  /// Handles notification response when the notification is tapped.
  void _handleNotificationResponse(String? screenName) {
    logger.i('Handling notification response: $screenName');
    if (screenName != null) {
      _pendingRoute = screenName;
      _processNavigation();
    }
  }

  /// Processes the pending navigation if any.
  void _processNavigation() {
    if (_pendingRoute == null) return;

    ref.read(navigationNotifierProvider).go(_pendingRoute!);
    _pendingRoute = null;
  }

  /// Should be called when the app is ready to handle navigation.
  void onAppReady() => _processNavigation();
}
