import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item.dart';

part 'moment_state.freezed.dart';

@freezed
class MomentState with _$MomentState {
  const factory MomentState({
    required EventItem moment,
    required bool isEditing,
    required bool hasChanges,
    required String title,
    required String description,
  }) = _MomentState;

  factory MomentState.initial(EventItem moment) => MomentState(
        moment: moment,
        isEditing: false,
        hasChanges: false,
        title: moment.name ?? '',
        description: moment.description ?? '',
      );
}
