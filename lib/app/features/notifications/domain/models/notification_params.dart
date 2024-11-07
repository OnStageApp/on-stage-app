import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_params.freezed.dart';
part 'notification_params.g.dart';

@Freezed()
class NotificationParams with _$NotificationParams {
  const factory NotificationParams({
    String? userId,
    String? eventId,
    String? teamId,
    String? stagerId,
    String? teamMembmerId,
    String? eventItemId,
    List<String>? usersWithPhoto,
    DateTime? date,
  }) = _NotificationParams;

  factory NotificationParams.fromJson(Map<String, dynamic> json) =>
      _$NotificationParamsFromJson(json);
}
