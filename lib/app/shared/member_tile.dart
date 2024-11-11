import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MemberTileWidget extends StatelessWidget {
  const MemberTileWidget({
    required this.name,
    required this.trailing,
    required this.onTap,
    super.key,
    this.photo,
  });

  final Uint8List? photo;
  final String? name;
  final String trailing;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: WidgetStateProperty.all(
        context.colorScheme.outline.withOpacity(0.1),
      ),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ImageWithPlaceholder(
              photo: photo,
              name: name!,
            ),
            const SizedBox(width: 10),
            Text(
              name ?? 'Unknown',
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
    );
  }
}
