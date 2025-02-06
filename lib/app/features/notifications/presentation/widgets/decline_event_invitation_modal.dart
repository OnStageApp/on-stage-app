import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_with_position.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class DeclineEventInvitationModal extends ConsumerStatefulWidget {
  const DeclineEventInvitationModal({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  DeclineEventInvitationModalState createState() =>
      DeclineEventInvitationModalState();
}

class DeclineEventInvitationModalState
    extends ConsumerState<DeclineEventInvitationModal> {
  List<StagerWithPosition> stagerWithPositions = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final stagers = await ref
          .read(eventNotifierProvider.notifier)
          .getStagersByCurrentUserAndEvent(widget.eventId);
      setState(() {
        stagerWithPositions = stagers;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDeclineInvitation(String stagerId) {
    ref.read(eventNotifierProvider.notifier).removeStagerById(stagerId);
    if (stagerWithPositions.length <= 1 && context.canPop()) {
      context.goNamed(AppRoute.events.name);
    } else {
      setState(() {
        stagerWithPositions
            .removeWhere((element) => element.stagerId == stagerId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stagerWithPositions.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: AdaptiveMenuContext(
        items: stagerWithPositions.map((stager) {
          return MenuAction(
            title: 'Decline Invitation for ${stager.positionName}',
            onTap: () => _onDeclineInvitation(stager.stagerId),
            icon: LucideIcons.calendar_x_2,
            isDestructive: true,
          );
        }).toList(),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: context.isDarkMode
                  ? const Color(0xFF43474E)
                  : context.colorScheme.onSurfaceVariant,
            ),
            child: Icon(
              LucideIcons.ellipsis_vertical,
              size: 15,
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
