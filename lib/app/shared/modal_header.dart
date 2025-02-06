import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    required this.title,
    this.titleWidget,
    this.leadingButton = const SizedBox(
      width: 80 - 12,
    ),
    super.key,
  });

  final String title;
  final Widget? titleWidget;
  final Widget? leadingButton;

  @override
  Widget build(BuildContext context) {
    // Determine if the screen is large and adjust text size dynamically
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;
    final titleStyle = context.textTheme.headlineSmall?.copyWith(
      fontSize: isLargeScreen ? 18.0 : 16.0,
      fontWeight: FontWeight.bold,
    );

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 82,
            height: 4,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leadingButton ?? const SizedBox(width: 80 - 12),
                if (titleWidget != null)
                  titleWidget!
                else
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle, // Apply the dynamic title style
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: 80,
                  child: IconButton(
                    iconSize: 18,
                    onPressed: () {
                      context.popDialog();
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.zero,
                      ),
                      visualDensity: VisualDensity.compact,
                      shape: WidgetStateProperty.all(
                        CircleBorder(
                          side: BorderSide(
                            color: context.colorScheme.surfaceContainer
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(
                      LucideIcons.x,
                      color: context.colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.smallNormal),
          Divider(
            color: context.colorScheme.surfaceContainer.withOpacity(0.3),
            height: 0,
          ),
        ],
      ),
    );
  }
}
