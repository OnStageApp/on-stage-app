import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/structure/structure.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditableStructureList extends ConsumerStatefulWidget {
  const EditableStructureList({required this.structure, super.key});

  final List<Structure> structure;

  @override
  EditableStructureListState createState() => EditableStructureListState();
}

class EditableStructureListState extends ConsumerState<EditableStructureList> {
  List<Widget> _widgets = [];

  List<Widget> calculate() {
    final widgets = <Widget>[];
    var xTimes = 1;
    for (var i = 0; i < widget.structure.length; i++) {
      if (i == widget.structure.length - 1) {
        widgets.add(_buildTile(widget.structure[i], xTimes));
        break;
      }
      if (widget.structure[i].item == widget.structure[i + 1].item) {
        xTimes++;
      } else {
        widgets.add(_buildTile(widget.structure[i], xTimes));
        xTimes = 1;
      }
    }
    return widgets;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _widgets = calculate();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _widgets,
      ),
    );
  }

  Widget _buildTile(Structure item, int xTimes) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(songNotifierProvider.notifier).selectSection(item.item);
          print('selected ${item.item.name}');
        },
        child: Container(
          padding: EdgeInsets.only(right: xTimes > 1 ? 16 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(item.item.color),
          ),
          margin: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
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
              if (xTimes > 1) ...[
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'x $xTimes',
                  style: context.textTheme.labelSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
