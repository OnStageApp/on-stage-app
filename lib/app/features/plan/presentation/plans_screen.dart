import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_carousel.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_duration_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void showPlanUpgrades(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useSafeArea: false,
    builder: (_) => const PlansScreen(),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0, 0.4],
            colors: [
              const Color(0xFFEAF5FD),
              context.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  color: context.colorScheme.outline,
                  onPressed: () {
                    context.popDialog();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: Text(
                  'Get more out of this sweet app',
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PlanDurationToggle(
                onToggle: () {
                  ref.read(planControllerProvider.notifier).toggleYearlyPlan();
                },
              ),
              const SizedBox(height: 18),
              Expanded(
                child: PlanCarousel(
                  pageController: _pageController,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 4,
                  effect: WormEffect(
                    dotColor: context.colorScheme.primaryContainer,
                    activeDotColor: context.colorScheme.onSecondary,
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Lorem ipsum dolor sit amet, '
                            'consectetur adipiscing elit. ',
                      ),
                      TextSpan(
                        text: 'Payment Policy',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
