import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/preferences_action_tile.dart';
import 'package:on_stage_app/app/reviews/review_service.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const StageAppBar(
        title: 'About',
        isBackButtonVisible: true,
      ),
      body: Padding(
        padding: defaultScreenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Connect with us',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            PreferencesActionTile(
              title: 'Rate us on the App Store',
              trailingIcon: Icons.keyboard_arrow_right_rounded,
              height: 54,
              onTap: () {
                ref.read(reviewServiceProvider).requestReview();
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Legal',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            PreferencesActionTile(
              title: 'Privacy Policy',
              trailingIcon: Icons.keyboard_arrow_right_rounded,
              height: 54,
              onTap: () {
                context.goNamed(AppRoute.privacyPolicy.name);
              },
            ),
            const SizedBox(height: 12),
            PreferencesActionTile(
              title: 'Terms Of Use',
              trailingIcon: Icons.keyboard_arrow_right_rounded,
              height: 54,
              onTap: () {
                context.goNamed(AppRoute.termsOfUse.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
