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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0, 0.4],
          colors: [
            if (context.isDarkMode)
              context.colorScheme.onSecondary
            else
              const Color(0xFFEAF5FD),
            context.colorScheme.surface,
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              color: context.colorScheme.outline,
              onPressed: () {
                context.popDialog();
              },
              icon: const Icon(
                Icons.close,
                size: 32,
              ),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                    ref
                        .read(planControllerProvider.notifier)
                        .toggleYearlyPlan();
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 480,
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
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Your monthly or annual subscription '
                              'automatically renews ',
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.outline,
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: 'automatically renews ',
                          style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                            fontSize: 11,
                          ),
                        ),
                        TextSpan(
                          text: 'for the same term unless cancelled at '
                              'least 24 hours prior to the end of the '
                              'current term. Cancel any time '
                              'in the App Store '
                              'at no additional cost; your subscription '
                              'will then cease at the end of '
                              'the current term.',
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.outline,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
