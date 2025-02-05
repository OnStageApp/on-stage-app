import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/controller/onboarding_fifth_controller.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class OnboardingFifthStep extends ConsumerStatefulWidget {
  const OnboardingFifthStep({super.key});

  @override
  ConsumerState<OnboardingFifthStep> createState() =>
      _OnboardingFifthStepState();
}

class _OnboardingFifthStepState extends ConsumerState<OnboardingFifthStep> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 128),
          Padding(
            padding: defaultScreenHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  enabled: true,
                  label: 'Username',
                  hint: 'Enter your username',
                  icon: Icons.person,
                  controller: _usernameController,
                  onChanged: (value) {
                    ref
                        .read(onboardingFifthControllerProvider.notifier)
                        .updateUsername(username: value);
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.large),
            child: TitleWidget(
              title: 'Personal Info',
              subtitle: "Let's finish setting up your account "
                  'by creating an username.',
            ),
          ),
        ],
      ),
    );
  }
}
