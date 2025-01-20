import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stager_overview.freezed.dart';
part 'stager_overview.g.dart';

@Freezed()
class StagerOverview with _$StagerOverview {
  const factory StagerOverview({
    required String id,
    required String name,
    required String userId,
    @JsonKey(includeFromJson: false) Uint8List? profilePicture,
  }) = _StagerOverview;

  factory StagerOverview.fromJson(Map<String, dynamic> json) =>
      _$StagerOverviewFromJson(json);
}
