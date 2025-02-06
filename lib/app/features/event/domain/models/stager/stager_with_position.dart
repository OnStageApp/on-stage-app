import 'package:freezed_annotation/freezed_annotation.dart';

part 'stager_with_position.freezed.dart';
part 'stager_with_position.g.dart';

@Freezed()
class StagerWithPosition with _$StagerWithPosition {
  const factory StagerWithPosition({
    required String stagerId,
    required String positionName,
  }) = _StagerWithPosition;

  factory StagerWithPosition.fromJson(Map<String, dynamic> json) =>
      _$StagerWithPositionFromJson(json);
}
