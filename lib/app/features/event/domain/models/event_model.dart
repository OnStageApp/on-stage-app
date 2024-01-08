import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed()
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    required DateTime date,
    required List<DateTime> rehearsalsDate,
    required List<String> staggersId,
    required List<String> adminsId,
    required List<String> eventItemIds,
    required String location,
    String? imageUrl,
  }) = _Event;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
