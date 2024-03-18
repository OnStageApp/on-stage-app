import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/structure/structure.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditableStructureList extends StatefulWidget {
  const EditableStructureList({super.key});

  @override
  _EditableStructureListState createState() => _EditableStructureListState();
}

class _EditableStructureListState extends State<EditableStructureList> {
  final List<Structure> _dummyStructure = [
    Structure(StructureItem.I, 0),
    Structure(StructureItem.V1, 1),
    Structure(StructureItem.C, 2),
    Structure(StructureItem.B, 3),
    Structure(StructureItem.C, 4),
    Structure(StructureItem.V2, 5),
    Structure(StructureItem.I, 6),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dummyStructure.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: _buildTile(_dummyStructure[index]),
          );
        },
      ),
    );
  }

  Widget _buildTile(Structure item) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        key: ValueKey(item.id),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(item.item.color),
            width: 3,
          ),
          shape: BoxShape.circle,
        ),
        child: Text(
          item.item.shortName,
          textAlign: TextAlign.center,
          style: context.textTheme.titleSmall,
        ),
      ),
    );
  }
}
