import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/widgets/onboarding_photo.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class OnboardingSecondStep extends StatelessWidget {
  const OnboardingSecondStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Insets.large),
        OnboardingPhoto(imagePath: 'assets/images/onboarding_second_step.png'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.large),
          child: TitleWidget(
            title: 'Event management',
            subtitle:
                'Create your event and invite your friends to join you. Here and now!',
          ),
        ),
      ],
    );
  }
}
