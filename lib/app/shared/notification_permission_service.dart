import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPermissionService extends StateNotifier<bool> {
  NotificationPermissionService() : super(false) {
    checkNotificationPermissions();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> checkNotificationPermissions() async {
    final NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();

    state = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<bool> requestNotificationPermission() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission();

    state = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    return state;
  }

}


final notificationPermissionProvider =
StateNotifierProvider<NotificationPermissionService, bool>((ref) {
  return NotificationPermissionService();
});

