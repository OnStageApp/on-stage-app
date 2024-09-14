import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MemberTileWidget extends StatelessWidget {
  const MemberTileWidget({
    super.key,
    this.photo,
    required this.name,
    required this.trailing,
    required this.onTap,
  });

  final String? photo;
  final String name;
  final String trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        overlayColor: WidgetStateProperty.all(
          context.colorScheme.outline.withOpacity(0.1),
        ),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              if (photo != null) ...[
                Image.asset(
                  photo!,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                name,
                style: context.textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                trailing,
                style: context.textTheme.titleMedium!
                    .copyWith(color: context.colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
