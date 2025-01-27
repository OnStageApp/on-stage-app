import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_overview.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AssignedPersons extends StatelessWidget {
  const AssignedPersons({required this.stagers, this.isSong = true, super.key});

  final List<StagerOverview> stagers;
  final bool isSong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SizedBox(
            width: stagers.length == 1
                ? 32
                : stagers.length == 2
                    ? 54
                    : 72,
            child: ParticipantsOnTile(
              borderColor: context.colorScheme.onSurfaceVariant,
              backgroundColor: isSong
                  ? context.colorScheme.tertiary
                  : context.colorScheme.onSurfaceVariant,
              participantsProfileName: stagers.map((e) => e.name).toList(),
              participantsLength: stagers.length,
              participantsProfileBytes:
                  stagers.map((e) => e.profilePicture).toList(),
              participantsMax: 2,
              width: 24,
            ),
          ),
          if (stagers.length > 1)
            AdaptiveMenuContext(
              items: stagers
                  .map(
                    (e) => MenuAction(
                      title: e.name ?? '',
                      image: e.profilePicture,
                    ),
                  )
                  .toList(),
              child: Row(
                children: [
                  Text(
                    isSong ? 'Lead Vocals' : 'Speakers',
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevron_down,
                    size: 16,
                  ),
                ],
              ),
            )
          else if (stagers.length == 1 || !isSong)
            Text(
              stagers.first.name ?? '',
              style: context.textTheme.bodyMedium!.copyWith(),
            ),
        ],
      ),
    );
  }
}
