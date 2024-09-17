import 'package:on_stage_app/app/app_data/app_data_state.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member_role/team_member_role.dart';
import 'package:on_stage_app/app/utils/constants.dart';
import 'package:on_stage_app/bootstrap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_data_controller.g.dart';

@Riverpod(keepAlive: true)
class AppDataController extends _$AppDataController {
  SharedPreferences? _prefs;

  SharedPreferences get prefs {
    _prefs ??= ref.read(sharedPreferencesProvider);
    return _prefs!;
  }

  @override
  AppDataState build() {
    print('AppDataController initialized');
    return _loadState();
  }

  AppDataState _loadState() {
    final roleString = prefs.getString(keyCurrentTeamMemberRole);
    final role = roleString != null
        ? TeamMemberRoleExtension.fromString(roleString)
        : null;
    print('role = $role');
    return const AppDataState().copyWith(
      role: role,
      hasEditorsRight: role == TeamMemberRole.Leader,
    );
  }

  Future<void> setMemberRole(TeamMemberRole role) async {
    await prefs.setString(
      keyCurrentTeamMemberRole,
      role.name,
    );
    print('role = $role');
    state = state.copyWith(
      role: role,
      hasEditorsRight: role == TeamMemberRole.Leader,
    );
  }

  Future<void> clearMemberRole() async {
    await prefs.remove(keyCurrentTeamMemberRole);
    state = state.copyWith(role: null, hasEditorsRight: false);
  }
}
