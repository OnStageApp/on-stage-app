import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    required this.title, required this.suffix, super.key,
    this.onTap,
    this.backgroundColor,
    this.headline,
  });

  final String title;
  final Widget suffix;
  final String? headline;
  final void Function()? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headline != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(headline!, style: context.textTheme.titleSmall),
          ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor ?? context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium,
                ),
                suffix,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
