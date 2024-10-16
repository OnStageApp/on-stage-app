import 'package:on_stage_app/app/features/notifications/application/notification_notifier_state.dart';
import 'package:on_stage_app/app/features/notifications/data/notification_repository.dart';
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
  NotificationNotifierState build() {
    _webSocketService = ref.read(webSocketServiceProvider);
    _initializeWebSocket();
    return const NotificationNotifierState();
  }

  Future<void> _initializeWebSocket() async {
    if (!webSocketService.isConnected) {
      await webSocketService.connect();
    }
    final userId = ref.watch(userNotifierProvider).currentUser?.id;
    if (userId != null) {
      webSocketService.subscribe(
        '${API.wsTopicMessage}/$userId/notifications',
        _handleNotification,
      );
    }
  }

  Future<void> _handleNotification(String message) async {
    logger.i('New notification message received: $message');
    await getNotifications();
    state = state.copyWith(hasNewNotifications: true);
  }

  Future<void> getNotifications() async {
    final userId = ref.read(userNotifierProvider).currentUser!.id;
    final notifications = await notificationRepository.getNotifications(userId);
    logger.i('getNotifications: $notifications');

    state = state.copyWith(notifications: notifications);
  }

  @override
  void dispose() {
    webSocketService.unsubscribe(API.wsTopicMessage);
  }
}
