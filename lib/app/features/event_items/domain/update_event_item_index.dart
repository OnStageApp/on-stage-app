import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_event_item_index.freezed.dart';
part 'update_event_item_index.g.dart';

@Freezed()
class UpdateEventItemIndex with _$UpdateEventItemIndex {
  const factory UpdateEventItemIndex({
    required String eventItemId,
    required int index,
  }) = _UpdateEventItemIndex;

  factory UpdateEventItemIndex.fromJson(Map<String, dynamic> json) =>
      _$UpdateEventItemIndexFromJson(json);
}
