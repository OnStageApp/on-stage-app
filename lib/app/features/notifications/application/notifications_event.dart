import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class GetNotifications extends NotificationsEvent {
  const GetNotifications({
    this.userId,
  });

  final String? userId;
  @override
  List<Object?> get props => [userId];
}
