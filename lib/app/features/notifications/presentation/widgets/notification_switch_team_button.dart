import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team/application/teams/teams_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class NotificationSwitchTeamButton extends ConsumerWidget {
  const NotificationSwitchTeamButton({
    required this.text,
    required this.teamId,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  final String text;
  final String? teamId;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        backgroundColor: WidgetStateProperty.all(context.colorScheme.tertiary),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return context.colorScheme.primary.withOpacity(0.1);
            }
            return null;
          },
        ),
      ),
      onPressed: () async {
        final currentTeamId = ref.watch(teamNotifierProvider).currentTeam?.id;
        if (teamId == currentTeamId) {
          context.pop();
          return;
        }
        if (teamId == null) {
          logger.e('Team ID is null');
          return;
        }
        logger.i('Switch to $text');

        final teamsNotifier = ref.read(teamsNotifierProvider.notifier);
        final teamNotifier = ref.read(teamNotifierProvider.notifier);
        final eventsNotifier = ref.read(eventsNotifierProvider.notifier);

        await teamsNotifier.setCurrentTeam(teamId!);

        if (!context.mounted) return;

        await teamNotifier.getCurrentTeam();

        if (!context.mounted) return;

        eventsNotifier.resetState();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.repeat_2,
            size: 20,
            color: textColor ?? Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
