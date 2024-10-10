import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/app_settings.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/library_section.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/profile_header.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/sign_out_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/song_view_settings.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/team_section.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart'; // Import the package

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FocusNode _songViewSettingsFocusNode = FocusNode();
  final OnboardingState _onboardingState = OnboardingState();
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  @override
  void initState() {
    super.initState();

    // Fetch current team data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(teamNotifierProvider.notifier).getCurrentTeam();

      // Start the onboarding process
      // onboardingKey.currentState?.show();
    });
  }

  @override
  void dispose() {
    // Dispose the focus node
    // _songViewSettingsFocusNode.dispose();
    super.dispose();
  }

//TODO: Complete steps for onboarding overlay
  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboardingKey,
      steps: [
        OnboardingStep(
          focusNode: _songViewSettingsFocusNode,
          titleText: 'Song View Settings',
          bodyText: 'Customize how your songs are displayed in the app.',
          overlayColor: context.colorScheme.secondary.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text('Profile', style: context.textTheme.headlineLarge),
                  const SizedBox(height: 32),
                  const ProfileHeader(),
                  const SizedBox(height: 24),
                  Focus(
                    focusNode: _songViewSettingsFocusNode,
                    child: const SongViewSettings(),
                  ),
                  const SizedBox(height: 24),
                  const TeamsSection(),
                  const SizedBox(height: 24),
                  const AppSettings(),
                  const SizedBox(height: 24),
                  const LibrarySection(),
                  const SizedBox(height: 24),
                  const SignOutButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
