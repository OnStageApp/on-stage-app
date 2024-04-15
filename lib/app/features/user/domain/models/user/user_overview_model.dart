import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_overview_model.freezed.dart';
part 'user_overview_model.g.dart';

@Freezed()
class UserOverview with _$UserOverview {
  const factory UserOverview({
    String? id,
    String? name,
    String? profileImage,
  }) = _UserOverview;

  factory UserOverview.fromJson(Map<String, dynamic> json) =>
      _$UserOverviewFromJson(json);
}
