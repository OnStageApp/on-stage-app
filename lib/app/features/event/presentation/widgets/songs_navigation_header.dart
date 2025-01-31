import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationHeader extends StatelessWidget {
  const NavigationHeader({
    super.key,
    required this.isLibrarySelected,
    required this.onSelectionChanged,
  });

  final bool isLibrarySelected;
  final ValueChanged<bool> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 16),
        child: Row(
          children: [
            NavigationButton(
              label: 'Songs',
              isSelected: !isLibrarySelected,
              onTap: () => onSelectionChanged(false),
            ),
            const SizedBox(width: 14),
            NavigationButton(
              label: 'My Library',
              hasInfo: true,
              isSelected: isLibrarySelected,
              onTap: () => onSelectionChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.hasInfo = false,
  });

  final String label;
  final bool isSelected;
  final bool hasInfo;
  final VoidCallback onTap;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: InkWell(
        onTap: () {
          widget.onTap();
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        overlayColor:
            MaterialStateProperty.all(theme.colorScheme.surfaceBright),
        child: AnimatedScale(
          scale: widget.isSelected ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 200),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(right: 6),
              child: Row(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: theme.textTheme.headlineLarge!.copyWith(
                      color: widget.isSelected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Text(widget.label),
                  ),
                  //TODO: Enable this at build time
                  // if (widget.hasInfo) ...[
                  //   const SizedBox(width: 6),
                  //   const InfoIcon(
                  //     message: 'All songs your team added or '
                  //         'customized will be kept here.',
                  //   ),
                  // ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
