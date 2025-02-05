import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
import 'package:on_stage_app/app/features/plan/presentation/plans_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSettings extends ConsumerStatefulWidget {
  const AppSettings({
    super.key,
  });

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends ConsumerState<AppSettings>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndUpdateNotificationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndUpdateNotificationStatus();
    }
  }

  Future<void> _checkAndUpdateNotificationStatus() async {
    final status = await Permission.notification.status;
    final currentNotificationSetting =
        ref.read(userSettingsNotifierProvider).isNotificationsEnabled ?? false;

    if (status.isGranted && !currentNotificationSetting) {
      await ref
          .read(userSettingsNotifierProvider.notifier)
          .setNotification(isActive: true);
    } else if (!status.isGranted && currentNotificationSetting) {
      await ref
          .read(userSettingsNotifierProvider.notifier)
          .setNotification(isActive: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(userSettingsNotifierProvider);
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
          value: userSettings.isNotificationsEnabled ?? false,
          onSwitch: (value) async {
            if (value) {
              final permissionGranted = await ref
                  .read(userSettingsNotifierProvider.notifier)
                  .requestNotificationPermission(context);

              if (!permissionGranted) return;
            }

            await ref
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
              "Team's Subscription",
              style: context.textTheme.titleMedium,
            ),
            trailing: Text(
              ref.watch(currentPlanProvider).name.split(' ')[0].toUpperCase(),
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.outline),
            ),
            onTap: () {
              showPlanUpgrades(context);
            },
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
