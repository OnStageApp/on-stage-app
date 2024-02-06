import 'package:freezed_annotation/freezed_annotation.dart';

part 'stager_overview.freezed.dart';
part 'stager_overview.g.dart';

@Freezed()
class StagerOverview with _$StagerOverview {
  const factory StagerOverview({
    required String id,
    required String firstName,
    required String lastName,
    required String picture,
  }) = _StagerOverview;

  factory StagerOverview.fromJson(Map<String, dynamic> json) =>
      _$StagerOverviewFromJson(json);
}
