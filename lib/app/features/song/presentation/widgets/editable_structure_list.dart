import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_state.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class EditableStructureList extends ConsumerStatefulWidget {
  const EditableStructureList({super.key});

  @override
  EditableStructureListState createState() => EditableStructureListState();
}

class EditableStructureListState extends ConsumerState<EditableStructureList> {
  List<Widget> _widgets = [];
  List<SongStructure> _structures = [];

  List<Widget> calculate() {
    _structures = ref
        .watch(songNotifierProvider)
        .sections
        .map((e) => e.structure)
        .toList();
    final widgets = <Widget>[];
    var xTimes = 1;
    for (var i = 0; i < _structures.length; i++) {
      if (i == _structures.length - 1) {
        widgets.add(_buildTile(_structures[i], xTimes));
        break;
      }
      if (_structures[i].item == _structures[i + 1].item) {
        xTimes++;
      } else {
        widgets.add(_buildTile(_structures[i], xTimes));
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
    _listenChangesForStructure();
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _widgets,
      ),
    );
  }

  void _listenChangesForStructure() {
    ref.listen<SongState>(songNotifierProvider, (previous, next) {
      setState(() {
        _widgets = calculate();
      });
    });
  }

  Widget _buildTile(SongStructure item, int xTimes) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(songNotifierProvider.notifier).selectSection(item.item);
          logger.i('selected ${item.item.name}');
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
