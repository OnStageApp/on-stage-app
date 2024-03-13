import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  const SongDetailScreen(
    this.song, {
    super.key,
  });

  final SongModel song;

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  int _transposeIncrement = 0;

  final _dummyStructure = [
    Structure('S1', 1),
    Structure('C', 2),
    Structure('S2', 3),
    Structure('B', 4),
    Structure('C', 5),
    Structure('S3', 6),
    Structure('C', 7),
    Structure('S4', 8),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: widget.song.title ?? '',
      ),
      body: Padding(
        padding: defaultScreenHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Key: ${song.key}'),
              const Text('Structura: S1, R, B, C, B, I'),
              SizedBox(
                height: 100,
                width: 300,
                child: ReorderableListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: _dummyStructure
                      .map((Structure item) => Container(
                            margin: const EdgeInsets.all(2),
                            color: Colors.red,
                            key: ValueKey(item.id),
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(item.name),
                          ))
                      .toList(),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      // If dragging an item to a position after itself, Flutter already accounts for the movement,
                      // so we need to subtract 1 from the new index.
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }

                      final Structure item = _dummyStructure.removeAt(oldIndex);
                      _dummyStructure.insert(newIndex, item);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _transposeIncrement--;
                      });
                    },
                    child: const Text('-'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _transposeIncrement++;
                      });
                    },
                    child: const Text('+'),
                  ),
                ],
              ),
              SongDetailWidget(
                transposeIncrement: _transposeIncrement,
                widgetPadding: 16 + 10,
                lyrics: song.lyrics ?? '',
                textStyle: context.textTheme.bodySmall!.copyWith(fontSize: 14),
                chordStyle: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                structureStyle: context.textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                onTapChord: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        error.toString(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: LoadingIndicator(
          colors: [Colors.black],
          indicatorType: Indicator.ballClipRotateMultiple,
        ),
      ),
    );
  }
}

class Structure {
  final String name;
  final int id;

  Structure(this.name, this.id);
}
