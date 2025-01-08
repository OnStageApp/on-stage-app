import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/positions/position_template/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/position_template/application/position_state.dart';
import 'package:on_stage_app/app/features/positions/position_template/presentation/widgets/position_card.dart';
import 'package:on_stage_app/app/features/positions/position_template/presentation/widgets/position_tile_shimmer.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PositionModal extends ConsumerStatefulWidget {
  const PositionModal({
    required this.groupId,
    super.key,
  });

  final String groupId;

  static Future<void> show({
    required BuildContext context,
    required String groupId,
  }) async {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        minHeight: MediaQuery.of(context).size.height * 0.95,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => PositionModal(groupId: groupId),
    );
  }

  @override
  ConsumerState<PositionModal> createState() => _PositionModalState();
}

class _PositionModalState extends ConsumerState<PositionModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(positionNotifierProvider.notifier)
          .getPositions(widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final positionState = ref.watch(positionNotifierProvider);

    if (positionState.error != null) {
      return Center(child: Text(positionState.error!));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Positions',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          _getContent(positionState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _getContent(PositionState positionState) {
    return switch ((positionState.isLoading, positionState.positions.isEmpty)) {
      (true, _) => const PositionTileShimmer(),
      (false, true) => EventActionButton(
          onTap: () {},
          text: 'New Position',
          icon: Icons.add,
        ),
      _ => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: positionState.positions.length,
          itemBuilder: (context, index) {
            final position = positionState.positions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PositionCard(
                positionId: position.id,
                onTap: () {},
              ),
            );
          },
        ),
    };
  }

  Widget _buildHeader(BuildContext context) {
    final group = ref.watch(groupTemplateNotifierProvider).groups.firstWhere(
          (group) => group.id == widget.groupId,
        );
    return ModalHeader(
      title: group.name,
      leadingButton: SizedBox(
        width: 80 - 12,
        child: AddNewButton(
          onPressed: () {},
        ),
      ),
    );
  }
}
