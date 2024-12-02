import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/plan/application/current_plan_provider.dart';
import 'package:on_stage_app/app/features/plan/presentation/plans_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/notification_permission_service.dart';
import 'package:on_stage_app/app/shared/utils.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/dialog_helper.dart';
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
    _checkNotificationPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermissions();
    }
  }

  Future<void> _checkNotificationPermissions() async {
    // Trigger the permission check in the provider
    await ref
        .read(notificationPermissionProvider.notifier)
        .checkNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final notificationPermission = ref.watch(notificationPermissionProvider);
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
          value: notificationPermission &&
              (userSettings.isNotificationsEnabled ?? true),
          onSwitch: (value) async {
            await ref
                .read(userSettingsNotifierProvider.notifier)
                .setNotification(isActive: value);

            if (value) {
              final status = await Permission.notification.status;
              if (!status.isGranted) {
                await requestPermission(
                  permission: Permission.notification,
                  context: context,
                  onSettingsOpen: () => openSettings(context),
                );
              }

              final updatedStatus = await Permission.notification.status;
              if (!updatedStatus.isGranted) {
                // If permission is not granted after requesting, disable notifications.
                await ref
                    .read(userSettingsNotifierProvider.notifier)
                    .setNotification(isActive: false);
              }
            }
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
              ref.watch(currentPlanProvider).name.split(' ')[0].toUpperCase(),
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
