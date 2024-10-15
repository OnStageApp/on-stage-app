import 'dart:convert';

import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:on_stage_app/app/web_socket/web_socket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  WebSocketService? _webSocketService;

  WebSocketService get webSocketService {
    _webSocketService ??= ref.read(webSocketServiceProvider);
    return _webSocketService!;
  }

  @override
  List<StageNotification> build() {
    _webSocketService = ref.read(webSocketServiceProvider);
    _initializeWebSocket();
    return [];
  }

  Future<void> _initializeWebSocket() async {
    if (!webSocketService.isConnected) {
      await webSocketService.connect();
    }
    final userId = ref.watch(userNotifierProvider).currentUser?.id;
    webSocketService.subscribe(
      '${API.wsTopicMessage}/$userId',
      _handleNotification,
    );
  }

  void _handleNotification(String message) {
    final notifMessage = message;
    final newNotification = StageNotification(
      id: 123,
      title: 'New Notification Arrived',
      dateTime: DateTime.now(),
      createdAt: 'notificats String',
      isInvitationConfirmed: true,
      seen: false,
      friendId: 1314.toString(),
      friendPhotoUrl: 'sadfass',
      eventId: 'dfasfsf',
    );

    // Update the state with the new notification added at the beginning of the list
    state = [newNotification, ...state];
  }

  Future<void> getNotifications() async {
    state = [...SongDummy.notificationsDummy];
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
