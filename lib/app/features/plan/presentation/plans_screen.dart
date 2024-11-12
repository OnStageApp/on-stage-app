import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/plan/presentation/controller/plan_controller.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_carousel.dart';
import 'package:on_stage_app/app/features/plan/presentation/widgets/plan_duration_toggle.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  height: 490,
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
                              'automatically automatically renews.'
                              ' Cancel any time '
                              'in the App Store '
                              'at no additional cost.',
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.outline,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLink('Terms of conditions', () {
                      openUrl(
                        'https://philosophical-stage-226575.framer.app/terms',
                      );
                    }),
                    _buildCircle(),
                    _buildLink('Privacy Policy', () {
                      openUrl(
                        'https://philosophical-stage-226575.framer.app/privacy',
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(String text, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: context.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCircle() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.circle,
        size: 5,
        color: context.colorScheme.onSurface,
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in browser
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
