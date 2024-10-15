import 'dart:convert';

import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/app/web_socket/web_socket_service.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  WebSocketService? _webSocketService;
  NotificationRepository? _notificationRepository;

  NotificationRepository get notificationRepository {
    _notificationRepository ??= NotificationRepository(ref.read(dioProvider));
    return _notificationRepository!;
  }

  WebSocketService get webSocketService {
    _webSocketService ??= ref.read(webSocketServiceProvider);
    return _webSocketService!;
  }

  @override
  List<StageNotification> build() {
    // _webSocketService = ref.read(webSocketServiceProvider);
    // _initializeWebSocket();
    return [];
  }

  Future<void> _initializeWebSocket() async {
    if (!webSocketService.isConnected) {
      await webSocketService.connect();
    }
    final userId = ref.watch(userNotifierProvider).currentUser?.id;
    webSocketService.subscribe(
      '${API.wsTopicMessage}/$userId/notifications',
      _handleNotification,
    );
  }

  void _handleNotification(String message) {
    // state = [newNotification, ...state];
  }

  Future<void> getNotifications() async {
    final userId = ref.read(userNotifierProvider).currentUser!.id;
    final notifications = await notificationRepository.getNotifications(userId);
    logger.i('getNotifications: $notifications');

    state = notifications;
  }

  void sendNotification(StageNotification notification) {
    final notificationJson = json.encode(notification.toJson());
    webSocketService.sendMessage('/app/notifications', notificationJson);
  }

  @override
  void dispose() {
    webSocketService.unsubscribe(API.wsTopicMessage);
    // super.dispose(); // Call super.dispose() to ensure the notifier is fully disposed
  }
}
