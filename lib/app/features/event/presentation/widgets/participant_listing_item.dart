import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantListingItem extends StatefulWidget {
  const ParticipantListingItem({
    required this.name,
    required this.assetPath,
    required this.status,
    required this.onDelete,
    super.key,
  });

  final String name;
  final String assetPath;
  final StagerStatusEnum status;
  final VoidCallback onDelete;

  @override
  State<ParticipantListingItem> createState() => _ParticipantListingItemState();
}

class _ParticipantListingItemState extends State<ParticipantListingItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.name),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dismissible: DismissiblePane(onDismissed: widget.onDelete),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDelete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Row(
          children: [
            Image.asset(
              widget.assetPath,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: context.textTheme.titleMedium,
            ),
            const Spacer(),
            if (widget.status != StagerStatusEnum.UNINVINTED)
              _statusIcon(widget.status),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(StagerStatusEnum status) {
    switch (widget.status) {
      case StagerStatusEnum.CONFIRMED:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case StagerStatusEnum.PENDING:
        return Icon(
          Icons.check_circle,
          color: context.colorScheme.surfaceBright,
        );
      case StagerStatusEnum.DECLINED:
        return Icon(
          Icons.cancel,
          color: context.colorScheme.error,
        );
      case StagerStatusEnum.UNINVINTED:
        return const SizedBox();
    }
  }
}
