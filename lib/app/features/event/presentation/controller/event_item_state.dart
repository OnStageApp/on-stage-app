import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_item_state.freezed.dart';

@freezed
class EventItemControllerState with _$EventItemControllerState {
  const factory EventItemControllerState({
    @Default(false) bool hasChanges,
    @Default(false) bool isButtonEnabled,
  }) = _EventItemControllerState;
}
