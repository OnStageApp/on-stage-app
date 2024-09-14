import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AppSettings extends ConsumerStatefulWidget {
  const AppSettings({
    required this.value,
    super.key,
  });

  final bool value;

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends ConsumerState<AppSettings> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
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
          value: ref.watch(themeProvider).theme != onStageLightTheme,
          onSwitch: (value) {
            ref.read(themeProvider.notifier).toggleTheme();
          },
        ),
        const SizedBox(height: 12),
        CustomSwitchListTile(
          title: 'Notifications',
          icon: Icons.notifications,
          value: !_value,
          onSwitch: (value) {
            setState(() {
              _value = !value;
            });
          },
        ),
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
            'Free',
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.outline),
          ),
          onTap: () {
            context.goNamed(AppRoute.favorites.name);
          },
        ),
      ],
    );
  }
}
