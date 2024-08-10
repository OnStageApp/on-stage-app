import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SearchFilter extends ConsumerWidget {
  const SearchFilter({
    required this.leadingIconPath,
    required this.labelText,
    required this.title,
    required this.onTap,
    super.key,
  });

  final String labelText;
  final String title;
  final String leadingIconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: context.textTheme.labelLarge,
          ),
          const SizedBox(height: Insets.small),
          PreferencesActionTile(
            leadingWidget: SvgPicture.asset(
              //'assets/icons/music_note.svg',
              leadingIconPath,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF74777F),
                BlendMode.srcIn,
              ),
            ),
            title: title,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
            onTap: onTap,
          ),
        ],

    );
  }
}
