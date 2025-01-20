import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StructureCircleWidget extends StatelessWidget {
  const StructureCircleWidget({
    required this.structureItem,
    super.key,
  });

  final StructureItem structureItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(4),
      key: ValueKey(structureItem.index),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        border: Border.all(
          color: Color(structureItem.color),
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AutoSizeText(
          structureItem.shortName,
          textAlign: TextAlign.center,
          style: context.textTheme.titleSmall,
          maxLines: 1,
        ),
      ),
    );
  }
}
