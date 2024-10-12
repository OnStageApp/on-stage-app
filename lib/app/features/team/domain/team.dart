import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required int? membersCount,
    @JsonKey(includeFromJson: false) @Default([]) List<Uint8List?> memberPhotos,
    @Default([]) List<String> membersUserIds,
    String? role,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
