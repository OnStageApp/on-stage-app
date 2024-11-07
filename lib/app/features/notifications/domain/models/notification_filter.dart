import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/notifications/domain/enums/notification_status.dart';

part 'notification_filter.freezed.dart';
part 'notification_filter.g.dart';

@Freezed()
class NotificationFilter with _$NotificationFilter {
  const factory NotificationFilter({
    NotificationStatus? status,
  }) = _NotificationFilter;

  factory NotificationFilter.fromJson(Map<String, dynamic> json) =>
      _$NotificationFilterFromJson(json);
}
