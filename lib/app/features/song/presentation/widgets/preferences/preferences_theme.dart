import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/theme_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferenceTheme extends ConsumerStatefulWidget {
  const PreferenceTheme({Key? key}) : super(key: key);

  @override
  PreferenceThemeState createState() => PreferenceThemeState();
}

class PreferenceThemeState extends ConsumerState<PreferenceTheme> {
  late String selectedTheme;

  final List<String> themes = ThemesDummy.themes;

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
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: Insets.small),
          PreferencesActionTile(

            title: selectedTheme,
            trailingIcon: Icons.keyboard_arrow_right_rounded,
            // onTap: () async {
            //   String? selected = await ThemeModal.show(context: context, initialTheme: selectedTheme);
            //   if (selected != null) {
            //     setState(() {
            //       selectedTheme = selected;
            //     });
            //   }
            // },
            onTap: () {
              ThemeModal.show(context: context);
            },
          ),
        ],
      ),
    );
  }
}
