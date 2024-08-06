import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

part 'stager_overview.freezed.dart';
part 'stager_overview.g.dart';

@Freezed()
class StagerOverview with _$StagerOverview {
  const factory StagerOverview({
    required String id,
    required String firstName,
    required String lastName,
    required String picture,
    required StagerStatusEnum status,
  }) = _StagerOverview;

  factory StagerOverview.fromJson(Map<String, dynamic> json) =>
      _$StagerOverviewFromJson(json);
}
