import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_stage_app/app/features/login/presentation/widgets/gradient_background.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_first_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_forth_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_second_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_third_step.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void showOnboardingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => const OnboardingScreen(),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const int _totalPages = 4;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    context.popDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          const GradientBackground(),
          Padding(
            padding: const EdgeInsets.only(bottom: 160),
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: const [
                OnboardingFirstStep(),
                OnboardingSecondStep(),
                OnboardingThirdStep(),
                OnboardingForthStep(),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SmoothPageIndicator(
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
        GestureDetector(
          onTap: _finishOnboarding,
          child: Text(
            'Skip',
            style: TextStyle(
              color: context.colorScheme.onSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButton() {
    return OnboardingButton(
      text: _currentPage < _totalPages - 1 ? 'Next' : 'Get Started',
      onPressed: _goToNextPage,
      isEnabled: true,
    );
  }
}
