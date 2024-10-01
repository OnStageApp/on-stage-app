import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';

part 'event_item_state.freezed.dart';

@Freezed()
class EventItemState with _$EventItemState {
  const factory EventItemState({
    @Default(false) bool isLoading,
    @Default([]) List<Stager> leadVocals,
    @Default([]) List<Stager> leadVocalsCacheList,
  }) = _EventItemState;
}
