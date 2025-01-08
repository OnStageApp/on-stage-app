import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';

part 'position_stagers.freezed.dart';
part 'position_stagers.g.dart';

@freezed
class PositionWithStagers with _$PositionWithStagers {
  const factory PositionWithStagers({
    required String id,
    required String groupId,
    required String name,
    required List<Stager> stagers,
  }) = _PositionWithStagers;

  factory PositionWithStagers.fromJson(Map<String, dynamic> json) =>
      _$PositionWithStagersFromJson(json);
}
