import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class EventsSearchBar extends StatelessWidget {
  const EventsSearchBar({
    required this.focusNode,
    required this.controller,
    required this.notifier,
    super.key,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final EventsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.normal,
        vertical: Insets.small,
      ),
      sliver: SliverToBoxAdapter(
        child: StageSearchBar(
          focusNode: focusNode,
          controller: controller,
          onClosed: () {
            focusNode.unfocus();
            notifier.searchEvents('');
            controller.clear();
          },
          onChanged: notifier.searchEvents,
        ),
      ),
    );
  }
}
