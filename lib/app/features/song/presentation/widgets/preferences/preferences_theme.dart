import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/theme_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceTheme extends ConsumerStatefulWidget {
  const PreferenceTheme({super.key});

  @override
  PreferenceThemeState createState() => PreferenceThemeState();
}

class PreferenceThemeState extends ConsumerState<PreferenceTheme> {
  late ThemeFilterEnum selectedTheme;

  final List<ThemeFilterEnum> themes = ThemesDummy.themes;

  @override
  void initState() {
    super.initState();
    selectedTheme = themes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: Insets.small),
          PreferencesActionTile(
            title: ref.watch(searchNotifierProvider).themeFilter?.name ??
                'All Themes',
            trailingIcon: Icons.keyboard_arrow_right_rounded,
            onTap: () {
              ThemeModal.show(context: context);
            },
          ),
        ],
      ),
    );
  }
}
