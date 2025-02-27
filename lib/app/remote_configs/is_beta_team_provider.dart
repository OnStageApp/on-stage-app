import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/remote_configs/remote_config_service.dart';

final isBetaTeamProvider = Provider<bool>((ref) {
  final currentTeam = ref.watch(teamNotifierProvider).currentTeam;
  final remoteConfigService = ref.watch(remoteConfigProvider);
  final betaTestingConfig = remoteConfigService.betaTestingConfig;
  return currentTeam != null &&
      betaTestingConfig.teamIds.contains(currentTeam.id);
});
