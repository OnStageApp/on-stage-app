import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@Freezed()
class Event with _$Event {
  const factory Event({
    required int id,
    required String name,
    required String date,
    required List<String> rehearsalsDate,
    required List<String> staggersId,
    required List<String> adminsId,
    required List<String> eventItemIds,
    required String location,
    String? imageUrl,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
