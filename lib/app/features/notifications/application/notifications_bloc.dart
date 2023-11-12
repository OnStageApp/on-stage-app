import 'package:bloc/bloc.dart';
import 'package:on_stage_app/app/features/notifications/application/notifications_event.dart';
import 'package:on_stage_app/app/features/notifications/application/notifications_state.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';

class NotificationBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationBloc({required this.notifications})
      : super(const NotificationsState()) {
    // on<GetNotifcations>(_handleGetNotifications);
  }

  final List<Song> notifications;
  final List<Song> todayNotifications = [];
  final List<Song> yesterdayNotifications = [];
  final List<Song> lastWeekNotifications = [];

  Future<void> _handleGetNotifications(
    GetNotifications event,
    Emitter<NotificationsState> emit,
  ) async {}
}
