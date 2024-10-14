import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/custom_text_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongContentView extends StatelessWidget {
  const SongContentView({
    required this.color,
    required this.shortName,
    required this.name,
    required this.onDelete,
    required this.controller,
    super.key,
  });

  final int color;
  final String shortName;
  final String name;
  final void Function() onDelete;
  final CustomTextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Color(
                      color,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          shortName,
                          style: context.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        name,
                        style: context.textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.shadow,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onDelete,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          CustomTextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
