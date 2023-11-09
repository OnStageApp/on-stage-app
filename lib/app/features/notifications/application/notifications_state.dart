import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/song/domain/song_model.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.notifications,
    this.notificationsCount = 0,
    this.notificationsLoading = false,
  });

  final List<Song>? notifications;
  final int notificationsCount;

  final bool notificationsLoading;

  @override
  List<Object> get props => [];

  NotificationsState copyWith({
    List<Song>? notifications,
    int? notificationsCount,
    bool? notificationsLoading,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      notificationsCount: notificationsCount ?? this.notificationsCount,
      notificationsLoading: notificationsLoading ?? this.notificationsLoading,
    );
  }
}
