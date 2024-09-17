import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';

part 'app_data_state.freezed.dart';

@freezed
class AppDataState with _$AppDataState {
  const factory AppDataState({
    bool? firstUse,
    String? firstName,
    TeamMemberRole? role,
    String? authType,
    String? refreshToken,
    String? accessToken,
    int? expiryInSeconds,
    String? session,
    String? phoneOrEmail,
    String? currentEnvironment,
    @Default(false) bool hasEditorsRight,
  }) = _AppDataState;
}
