import 'dart:async';

import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  ref.onDispose(() {
    ref
      ..invalidate(firebaseNotifierProvider)
      ..invalidate(loginNotifierProvider)
      ..invalidate(databaseProvider)
      ..invalidate(currentTeamMemberNotifierProvider)
      ..invalidate(userNotifierProvider)
      ..invalidate(teamMembersNotifierProvider);
  });

  logger.i('appStartup');
  await ref.read(firebaseNotifierProvider.future);
  ref.read(firebaseNotifierProvider.notifier).onAppReady();
  ref.read(databaseProvider);
  await ref.read(userSettingsNotifierProvider.notifier).init();
  unawaited(ref.read(userNotifierProvider.notifier).init());
}
