import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantListingItem extends StatelessWidget {
  const ParticipantListingItem({
    required this.name,
    required this.photo,
    required this.onDelete,
    this.status,
    this.trailing,
    super.key,
  });

  final String name;
  final Uint8List? photo;
  final StagerStatusEnum? status;
  final Widget? trailing;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(name),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dismissible: DismissiblePane(onDismissed: onDelete),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.colorScheme.primaryContainer,
                ),
                shape: BoxShape.circle,
                image: photo != null && photo!.isNotEmpty
                    ? DecorationImage(
                        image: MemoryImage(photo!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: photo == null || photo!.isEmpty
                  ? Icon(
                      Icons.person,
                      color: context.colorScheme.primaryContainer,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: context.textTheme.titleMedium,
            ),
            const Spacer(),
            if (trailing != null) trailing!,
            if (trailing == null && status != StagerStatusEnum.UNINVINTED)
              _statusIcon(context, status!),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(BuildContext context, StagerStatusEnum status) {
    switch (status) {
      case StagerStatusEnum.CONFIRMED:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case StagerStatusEnum.PENDING:
        return Icon(
          Icons.check_circle,
          color: context.colorScheme.surfaceContainer,
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
