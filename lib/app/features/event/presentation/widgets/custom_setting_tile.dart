import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    this.controller,
    required this.placeholder,
    required this.suffix,
    super.key,
    this.onTap,
    this.backgroundColor,
    this.headline,
  });

  final TextEditingController? controller;
  final Widget suffix;
  final String? headline;
  final void Function()? onTap;
  final Color? backgroundColor;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headline != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
                Expanded(
                  child: TextField(
                    controller: controller ?? TextEditingController(),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                    enabled: controller != null,
                    decoration: InputDecoration(
                      focusColor: context.colorScheme.error,
                      hoverColor: context.colorScheme.error,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: placeholder,
                      hintStyle: context.textTheme.titleMedium!.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
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
