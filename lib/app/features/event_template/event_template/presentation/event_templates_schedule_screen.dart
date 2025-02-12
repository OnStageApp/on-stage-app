import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/application/event_item_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/domain/event_item_template.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/presentation/add_edit_moment_on_event_template.dart';
import 'package:on_stage_app/app/features/event_template/event_item_template/presentation/event_item_template_tile.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

final evTemplatesHasChangesProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class EventTemplateScheduleScreen extends ConsumerStatefulWidget {
  const EventTemplateScheduleScreen({
    required this.eventTemplateId,
    super.key,
  });

  final String eventTemplateId;

  @override
  EventTemplateScheduleScreenState createState() =>
      EventTemplateScheduleScreenState();
}

class EventTemplateScheduleScreenState
    extends ConsumerState<EventTemplateScheduleScreen> {
  bool _areEventItemsTemplateLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestEventItemTemplates();
    });
    super.initState();
  }

  Future<void> _requestEventItemTemplates() async {
    setState(() {
      _areEventItemsTemplateLoading = true;
    });
    await ref
        .read(eventItemTemplatesNotifierProvider.notifier)
        .getEventItemTemplates(widget.eventTemplateId);

    setState(() {
      _areEventItemsTemplateLoading = false;
    });
  }

  void _saveChanges() {
    if (ref.watch(evTemplatesHasChangesProvider)) {
      _saveReorder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final evTemplateState = ref.watch(eventItemTemplatesNotifierProvider);

    return Scaffold(
      appBar: const StageAppBar(
        title: 'Schedule',
        isBackButtonVisible: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSaveButton(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      body: SlidableAutoCloseBehavior(
        child: RefreshIndicator.adaptive(
          onRefresh: _requestEventItemTemplates,
          child: Padding(
            padding: defaultScreenPadding,
            child: _areEventItemsTemplateLoading
                ? _buildShimmerList()
                : _buildReordableList(evTemplateState.eventItemTemplates),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Shimmer.fromColors(
          baseColor: context.colorScheme.onSurfaceVariant.withAlpha(10),
          highlightColor: context.colorScheme.onSurfaceVariant,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final hasChanges = ref.watch(evTemplatesHasChangesProvider);
    if (!hasChanges) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ContinueButton(
        text: 'Save Order',
        onPressed: hasChanges ? _saveChanges : () {},
        isEnabled: hasChanges,
      ),
    );
  }

  void _saveReorder() {
    ref
        .read(eventItemTemplatesNotifierProvider.notifier)
        .updateEventItemTemplatesIndexes();

    ref.read(evTemplatesHasChangesProvider.notifier).state = false;
  }

  Widget _buildReordableList(List<EventItemTemplate> evItemTemplates) {
    return SlidableAutoCloseBehavior(
      child: ReorderableListView.builder(
        proxyDecorator: _proxyDecorator,
        itemCount: evItemTemplates.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) =>
            _buildEventItemTile(evItemTemplates[index]),
        footer: _buildAddMomentsButton(),
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final animValue = Curves.easeIn.transform(animation.value);
        final scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            color: context.colorScheme.surface.withAlpha(10),
            elevation: 6,
            shadowColor: Colors.black.withAlpha(10),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    ref
        .read(eventItemTemplatesNotifierProvider.notifier)
        .changeOrderCache(oldIndex, newIndex);
    ref.read(evTemplatesHasChangesProvider.notifier).state = true;
  }

  Widget _buildEventItemTile(
    EventItemTemplate evItemTemplate,
  ) {
    return EventItemTemplateTile(
      key: ValueKey(evItemTemplate.hashCode),
      eventItemTemplate: evItemTemplate,
      onDelete: () {
        ref
            .read(eventItemTemplatesNotifierProvider.notifier)
            .deleteEventItem(evItemTemplate.id);
      },
      onTap: () {
        if (ref.watch(evTemplatesHasChangesProvider)) {
          TopFlushBar.show(
            context,
            'Save order before editing moments',
            backgroundColor: Colors.orangeAccent,
          );
          return;
        }
        AddEditMomentOnEventTemplate.show(
          eventTemplateId: widget.eventTemplateId,
          context: context,
          eventItemTemplate: evItemTemplate,
        );
      },
    );
  }

  Widget _buildAddMomentsButton() {
    if (ref.watch(evTemplatesHasChangesProvider)) {
      return const SizedBox(height: 160);
    }
    return Column(
      children: [
        EventActionButton(
          onTap: () => AddEditMomentOnEventTemplate.show(
            eventTemplateId: widget.eventTemplateId,
            context: context,
          ),
          text: 'Add Moments',
          icon: Icons.add,
        ),
        const SizedBox(height: 160),
      ],
    );
  }
}
