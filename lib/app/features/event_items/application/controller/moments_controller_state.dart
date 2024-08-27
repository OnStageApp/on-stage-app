import 'package:freezed_annotation/freezed_annotation.dart';

part 'moments_controller_state.freezed.dart';

@Freezed()
class MomentsControllerState with _$MomentsControllerState {
  const factory MomentsControllerState({
    @Default([]) List<String> moments,
  }) = _MomentsControllerState;
}
