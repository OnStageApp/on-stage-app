import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class EventStructureButton extends StatelessWidget {
  const EventStructureButton({
    required this.onTap,
    super.key,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/music_note_icon.svg',
              color: Colors.blue,
            ),
            const SizedBox(width: 4),
            Text(
              'Event Structure',
              style: context.textTheme.titleMedium!.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
            const Spacer(),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Assets.icons.arrowForward.svg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
