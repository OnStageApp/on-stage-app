import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class OnboardingFirstStep extends StatelessWidget {
  const OnboardingFirstStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Insets.large),
        Expanded(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  'assets/images/onboarding_first_step.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.large),
          child: TitleWidget(
            title: 'Edit your structure',
            subtitle:
                'Create your team and invite your friends to join you. Here and now!',
          ),
        ),
      ],
    );
  }
}
