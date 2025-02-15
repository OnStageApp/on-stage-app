import 'package:freezed_annotation/freezed_annotation.dart';

part 'combined_player_state.freezed.dart';

@freezed
class CombinedPlayerState with _$CombinedPlayerState {
  const factory CombinedPlayerState({
    required Duration position,
    required Duration bufferedPosition,
    required Duration duration,
    required bool isPlaying,
  }) = _CombinedPlayerState;
}
