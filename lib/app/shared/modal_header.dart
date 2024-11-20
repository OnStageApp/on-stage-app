import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    required this.title,
    this.leadingButton = const SizedBox(
      width: 80,
    ),
    super.key,
  });

  final String title;
  final Widget leadingButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
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
          const SizedBox(height: Insets.normal),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leadingButton,
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: () {
                      context.popDialog();
                    },
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.surfaceContainer
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: context.colorScheme.outline,
                        ),
                      ),
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
