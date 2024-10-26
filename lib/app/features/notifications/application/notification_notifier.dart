import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/web_socket/web_socket_service.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_notifier.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  NotificationRepository? _notificationRepository;

  NotificationRepository get notificationRepository {
    _notificationRepository ??= NotificationRepository(ref.read(dioProvider));
    return _notificationRepository!;
  }

  @override
  NotificationNotifierState build() {
    _initializeWebSocket();
    return const NotificationNotifierState();
  }

  void _initializeWebSocket() {
    final webSocketService = ref.read(webSocketServiceProvider.notifier);
    final userId = ref.read(userNotifierProvider).currentUser?.id;

    // if (userId != null) {
    //TODO: When BE is ready we will have events named 'notigications'
    //TODO: We will listen to /websocket.io/notifications/device/{deviceId} ( so we will handle multiple devices at a time )
    //TODO: When sending a notification we will send param the notification_type, with some data
    webSocketService.on('song', _handleNotification);

    logger.i('WebSocket initialized for user: $userId');
    // }
  }

  Future<void> _handleNotification(dynamic data) async {
    logger.i('New notification received: $data');

    final notification = data is String ? data : data as Map<String, dynamic>;

    await getNotifications();

    state = state.copyWith(hasNewNotifications: true);
  }

  Future<void> getNotifications() async {
    try {
      final userId = ref.read(userNotifierProvider).currentUser?.id;
      if (userId == null) return;

      final notifications =
          await notificationRepository.getNotifications(userId);
      logger.i('Retrieved notifications: $notifications');

      state = state.copyWith(notifications: notifications);
    } catch (e) {
      logger.e('Error getting notifications: $e');
    }
  }

  void markNotificationsAsRead() {
    state = state.copyWith(hasNewNotifications: false);
  }

  @override
  void dispose() {
    final webSocketService = ref.read(webSocketServiceProvider.notifier);
    final userId = ref.read(userNotifierProvider).currentUser?.id;

    if (userId != null) {
      webSocketService.off('song');
    }
  }
}
