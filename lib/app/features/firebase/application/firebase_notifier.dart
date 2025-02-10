import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:on_stage_app/app/device/application/device_service.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/application/teams/teams_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_notifier.g.dart';

/// Background message handler for Firebase Messaging.
/// This function must be a top-level function to be called by the OS.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final notification = message.notification;
  final android = notification?.android;

  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
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

    // For Android 13+
    if (Platform.isAndroid) {
      final androidImplementation =
          _localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }
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
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handleScreenRoutesChange(response.payload!);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'high_importance_channel', // ID must match in AndroidNotificationDetails
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    final androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
    }

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
    // Add this handler for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              icon: '@mipmap/ic_launcher',
              priority: Priority.high,
              importance: Importance.high,
            ),
          ),
          payload: message.data['screen'] as String?,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationResponseData(message.data);
    });
  }

  /// Handles notification response when the notification is tapped.

  void _handleNotificationResponseData(Map<String, dynamic> data) {
    final teamId = data['teamId'] as String?;
    final screen = data['screen'] as String?;

    if (screen != null) {
      _handleScreenRoutesChange(screen);
    } else if (teamId != null) {
      _handleNotificationTeamChange(teamId);
    } else {
      ref.read(navigationNotifierProvider).goNamed(AppRoute.notification.name);
    }
  }

  void _handleScreenRoutesChange(String screenName) {
    _pendingRoute = screenName;
    _processNavigation();
  }

  Future<void> _handleNotificationTeamChange(String teamId) async {
    try {
      final currentTeamId = ref.read(teamNotifierProvider).currentTeam?.id;
      if (currentTeamId == null || teamId == currentTeamId) {
        return;
      }

      final teamNotifier = ref.read(teamNotifierProvider.notifier);
      final eventsNotifier = ref.read(eventsNotifierProvider.notifier);
      final teamsNotifier = ref.read(teamsNotifierProvider.notifier);
      await teamsNotifier.getTeams();

      final containsTeamToSwitch = ref
          .watch(teamsNotifierProvider)
          .teams
          .where((element) => element.id == teamId)
          .toList();

      if (containsTeamToSwitch.isEmpty) {
        logger.i('Team cannot be changed. Team not found in existing teams');
        return;
      }

      await teamsNotifier.setCurrentTeam(teamId);
      await teamNotifier.getCurrentTeam();
      eventsNotifier.resetState();
    } catch (e, stackTrace) {
      logger.e('Team change failed', e, stackTrace);
      rethrow;
    }
  }

  /// Processes the pending navigation if any.
  void _processNavigation() {
    if (_pendingRoute == null) return;

    ref.read(navigationNotifierProvider).pushNamed(_pendingRoute!);
    _pendingRoute = null;
  }

  /// Should be called when the app is ready to handle navigation.
  void onAppReady() => _processNavigation();
}
