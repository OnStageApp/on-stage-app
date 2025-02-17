import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EmptyEventTemplates extends ConsumerWidget {
  const EmptyEventTemplates(
      {required this.onTap, this.includeIcon = true, super.key});

  final void Function() onTap;
  final bool includeIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (includeIcon) ...[
          SvgPicture.asset(
            'assets/icons/folders_v2.svg',
            colorFilter: ColorFilter.mode(
              context.colorScheme.outline,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
        ],
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "You don't have any \ntemplates, ",
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.outline),
            children: [
              TextSpan(
                text: 'add one.',
                style: context.textTheme.titleMedium!
                    .copyWith(color: context.colorScheme.primary),
                recognizer: TapGestureRecognizer()..onTap = onTap.call,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
