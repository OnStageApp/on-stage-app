import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
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

  var _isReorderEnabled = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: StageAppBar(
        background: const Color(0xFFF4F4F4),
        isBackButtonVisible: true,
        title: widget.song.title ?? '',
        trailing: _buildLeading(context),
      ),
      body: Padding(
        padding: defaultScreenHorizontalPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Insets.normal,
              ),
              const EditableStructureList(),
              const SizedBox(
                height: Insets.normal,
              ),
              // Row(
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           _transposeIncrement--;
              //         });
              //       },
              //       child: const Text('-'),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           _transposeIncrement++;
              //         });
              //       },
              //       child: const Text('+'),
              //     ),
              //   ],
              // ),
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

  Row _buildLeading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onPressed: () {
            setState(() {
              _isReorderEnabled = !_isReorderEnabled;
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Text('G Major',
                style: context.textTheme.titleSmall,
                textAlign: TextAlign.center),
          ),
        ),
        SizedBox(
          width: Insets.small,
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isReorderEnabled = !_isReorderEnabled;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              'assets/icons/mixer_horizontal.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF74777F),
                BlendMode.srcIn,
              ),
              height: 16,
              width: 16,
            ),
          ),
        ),
      ],
    );
  }
}
