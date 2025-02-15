import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/current_event_template_notifier.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_background.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/widgets/onboarding_photo.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

void showEventTemplateFeature(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => const EventTemplateFeatureWall(),
  );
}

class EventTemplateFeatureWall extends ConsumerWidget {
  const EventTemplateFeatureWall({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Stack(
        children: [
          const GradientBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Padding(
                padding: context.isLargeScreen
                    ? const EdgeInsets.only(
                        left: 160,
                        right: 160,
                      )
                    : EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      ref
                          .read(userSettingsNotifierProvider.notifier)
                          .setEventTemplateFeatureWallShown();
                      context.popDialog();
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: context.isLargeScreen ? 24 : 18,
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
              const OnboardingPhoto(
                smallScreenImageFactor: 1,
                largeScreenImageFactor: 0.6,
                imagePath: 'assets/images/event_templates_feature_wall.png',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.large),
                child: TitleWidget(
                  title: 'New Feature!',
                  subtitle: 'Build your own Event Templates and save time on '
                      'creating events.',
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContinueButton(
                    text: 'Create your Event Template',
                    backgroundColor: context.colorScheme.secondary,
                    // borderColor: context.colorScheme.primary,
                    onPressed: () async {
                      unawaited(
                        ref
                            .read(userSettingsNotifierProvider.notifier)
                            .setEventTemplateFeatureWallShown(),
                      );
                      final savedTemplate = await ref
                          .read(currentEventTemplateProvider.notifier)
                          .createEmptyEventTemplate();
                      if (context.mounted) {
                        context.popDialog();
                        unawaited(
                          context.pushNamed(
                            AppRoute.eventTemplateDetails.name,
                            extra: savedTemplate,
                            queryParameters: {'isNew': 'true'},
                          ),
                        );
                      }
                    },
                    isEnabled: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
