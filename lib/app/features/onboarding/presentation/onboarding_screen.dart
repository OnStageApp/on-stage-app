import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_background.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/controller/onboarding_fifth_controller.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_fifth_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_first_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_forth_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_second_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_third_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:on_stage_app/app/features/plan/presentation/plans_screen.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void showOnboardingOverlay(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => const OnboardingScreen(),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _totalPages = 5;
  static const _onboardingSteps = [
    OnboardingFirstStep(),
    OnboardingSecondStep(),
    OnboardingThirdStep(),
    OnboardingForthStep(),
    OnboardingFifthStep(),
  ];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage == _totalPages - 1) {
      _updateUser();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    ref.read(userSettingsNotifierProvider.notifier).setOnboardingDone();
    context.popDialog();
  }

  @override
  Widget build(BuildContext context) {
    _setupErrorListener();

    return Material(
      child: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: context.isLargeScreen
                ? const EdgeInsets.only(
                    left: 160,
                    right: 160,
                    bottom: 160,
                  )
                : const EdgeInsets.only(bottom: 160),
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              children: _onboardingSteps,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  _buildHeader(),
                  const Spacer(),
                  _buildNavigationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      child: SmoothPageIndicator(
        controller: _pageController,
        count: _totalPages,
        effect: WormEffect(
          dotColor: context.colorScheme.primaryContainer,
          activeDotColor: context.colorScheme.onSecondary,
          dotHeight: 12,
          dotWidth: 12,
          spacing: 10,
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return OnboardingButton(
      text: _currentPage < _totalPages - 1 ? 'Next' : 'Get Started',
      onPressed: _goToNextPage,
      isEnabled: true,
    );
  }

  Future<void> _updateUser() async {
    final username = ref.watch(onboardingFifthControllerProvider).username;
    final success = await ref
        .read(userNotifierProvider.notifier)
        .updateUsernameOnUser(username);

    if (success) {
      _finishOnboarding();
      showPlanUpgrades(context);
    }
  }

  void _setupErrorListener() {
    ref.listen(
      userNotifierProvider.select((state) => state.error),
      (previous, next) {
        if (next != null && mounted) {
          TopFlushBar.show(
            context,
            next,
            isError: true,
          );
        }
      },
    );
  }
}
