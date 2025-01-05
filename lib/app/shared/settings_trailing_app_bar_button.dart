import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SettingsTrailingAppBarButton extends ConsumerWidget {
  const SettingsTrailingAppBarButton({
    required this.onTap,
    this.iconPath,
    this.rightPadding = 6,
    super.key,
  });

  final void Function() onTap;
  final String? iconPath;
  final double rightPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: IconButton(
        style: IconButton.styleFrom(
          visualDensity: VisualDensity.compact,
          enableFeedback: true,
          highlightColor: context.colorScheme.surfaceBright,
          backgroundColor: context.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onTap,
        icon: SvgPicture.asset(
          iconPath ?? 'assets/icons/mixer_horizontal.svg',
          colorFilter: ColorFilter.mode(
            context.colorScheme.outline,
            BlendMode.srcIn,
          ),
          height: 16,
          width: 16,
        ),
      ),
    );
  }
}
