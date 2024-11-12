import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
import 'package:on_stage_app/app/features/plan/presentation/plans_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AppSettings extends ConsumerStatefulWidget {
  const AppSettings({
    super.key,
  });

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends ConsumerState<AppSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Settings',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        CustomSwitchListTile(
          title: 'Dark Mode',
          icon: Icons.dark_mode,
          value: ref.watch(userSettingsNotifierProvider).isDarkMode ?? false,
          onSwitch: (value) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .toggleDarkMode(isDarkMode: value);
          },
        ),
        const SizedBox(height: 12),
        CustomSwitchListTile(
          title: 'Notifications',
          icon: Icons.notifications,
          value:
              ref.watch(userSettingsNotifierProvider).isNotificationsEnabled ??
                  true,
          onSwitch: (value) {
            ref
                .read(userSettingsNotifierProvider.notifier)
                .setNotification(isActive: value);
          },
        ),
        if (ref.watch(permissionServiceProvider).isLeaderOnTeam) ...[
          const SizedBox(height: 12),
          ListTile(
            splashColor: context.colorScheme.surfaceBright,
            tileColor: context.colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.person,
              color: context.colorScheme.outline,
            ),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            title: Text(
              'Membership Plan',
              style: context.textTheme.titleMedium,
            ),
            trailing: Text(
              ref.watch(currentPlanProvider).name,
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
            onTap: () {
              showPlanUpgrades(context);
            },
          ),
          const SizedBox(height: 12),
        ]
      ],
    );
  }
}
