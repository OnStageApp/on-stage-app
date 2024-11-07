import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/notification_model.dart';

part 'notification_pagination.freezed.dart';
part 'notification_pagination.g.dart';

@Freezed()
class NotificationPagination with _$NotificationPagination {
  const factory NotificationPagination({
    @Default([]) List<StageNotification> notifications,
    bool? hasMore,
  }) = _NotificationPagination;

  factory NotificationPagination.fromJson(Map<String, dynamic> json) =>
      _$NotificationPaginationFromJson(json);
}
