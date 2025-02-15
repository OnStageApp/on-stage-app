import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/event_template/presentation/event_template_feature_wall.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/app_settings.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/library_section.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/profile_header.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/sign_out_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/team_section.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/app_version.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/env_switcher_widget.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart'; // Import the package

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FocusNode _songViewSettingsFocusNode = FocusNode();
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(teamNotifierProvider.notifier).getCurrentTeam();
      _checkIfEventTemplatesWallShouldBeShown();
    });
  }

  void _checkIfEventTemplatesWallShouldBeShown() {
    final isLeaderOnTeam = ref.watch(permissionServiceProvider).isLeaderOnTeam;
    final isEventTemplatesFeatureWallShown = ref
            .watch(userSettingsNotifierProvider)
            .isEventTemplatesFeatureWallShown ??
        false;
    // if (isEventTemplatesFeatureWallShown == false && isLeaderOnTeam) {
    showEventTemplateFeature(context);
    // }/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      key: onboardingKey,
      steps: [
        OnboardingStep(
          focusNode: _songViewSettingsFocusNode,
          titleText: 'Song View Settings',
          bodyText: 'Customize how your songs are displayed in the app.',
          overlayColor: context.colorScheme.secondary.withAlpha(200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
      child: Padding(
        padding: getResponsivePadding(context),
        child: Scaffold(
          appBar: const StageAppBar(
            title: 'Profile',
          ),
          body: RefreshIndicator.adaptive(
            displacement: 0,
            onRefresh: () async {
              await ref
                  .read(subscriptionNotifierProvider.notifier)
                  .getCurrentSubscription(forceUpdate: true);
              await ref.read(teamNotifierProvider.notifier).getCurrentTeam();
              await ref
                  .read(currentTeamMemberNotifierProvider.notifier)
                  .initializeState();
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Insets.normal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const ProfileHeader(),
                      const SizedBox(height: 24),
                      const TeamsSection(),
                      const SizedBox(height: 24),
                      const AppSettings(),
                      const SizedBox(height: 24),
                      const LibrarySection(),
                      const SizedBox(height: 24),
                      EnvSwitcher(
                        child: Text(
                          'Account',
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SignOutButton(),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: VersionDisplay(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
