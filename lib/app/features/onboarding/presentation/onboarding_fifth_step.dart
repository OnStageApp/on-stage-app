import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/title_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class OnboardingFifthStep extends ConsumerStatefulWidget {
  const OnboardingFifthStep({super.key});

  @override
  ConsumerState<OnboardingFifthStep> createState() =>
      _OnboardingFifthStepState();
}

class _OnboardingFifthStepState extends ConsumerState<OnboardingFifthStep> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
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
                Text(
                  'Position',
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: Insets.small),
                //TODO: Maybe add this in future
                // PositionTile(
                //   title: ref
                //       .watch(onboardingFifthControllerProvider)
                //       .position
                //       ?.title,
                //   onSaved: (position) {
                //     ref
                //         .read(onboardingFifthControllerProvider.notifier)
                //         .updatePosition(position: position);
                //   },
                // ),
              ],
            ),
          ),
          const SizedBox(height: Insets.medium),
          const SizedBox(height: Insets.medium),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.large),
            child: TitleWidget(
              title: 'Personal Info',
              subtitle:
                  "Let's finish setting up your account by adding your personal information.",
            ),
          ),
        ],
      ),
    );
  }
}
