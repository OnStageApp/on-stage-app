import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TitleWidget extends StatefulWidget {
  const TitleWidget({
    Key? key,
    this.title,
    this.subtitle,
    this.subtitleFontSize,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final double? subtitleFontSize;

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _subtitleSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    _titleFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeOut,
        ),
      ),
    );

    _subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.3,
          0.9,
          curve: Curves.easeOut,
        ),
      ),
    );

    _subtitleFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.3,
          0.9,
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SlideTransition(
            position: _titleSlideAnimation,
            child: FadeTransition(
              opacity: _titleFadeAnimation,
              child: Text(
                widget.title ?? 'Plan together.\nWorship together.',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  fontSize: 32,
                  color: context.isDarkMode
                      ? context.colorScheme.onSurface
                      : context.colorScheme.onSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (widget.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: SlideTransition(
                position: _subtitleSlideAnimation,
                child: FadeTransition(
                  opacity: _subtitleFadeAnimation,
                  child: Text(
                    widget.subtitle!,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.isDarkMode
                          ? context.colorScheme.onSurface
                          : context.colorScheme.onSecondary,
                      fontSize: widget.subtitleFontSize ?? 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
