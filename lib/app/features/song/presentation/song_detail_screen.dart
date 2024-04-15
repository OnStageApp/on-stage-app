import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songNotifierProvider.notifier).init();
      // ref.listen(preferencesNotifierProvider, (previous, next) {
      //   print('asdasdasdasdasdasdasdasdasdsadsadasd');
      //   setState(() {});
      // });
    });

    // ref.listen<PreferencesState>(preferencesNotifierProvider, (previous, next) {
    //   print('asdasdasdasdasdasdasdasdasdsadsadasd');
    //   setState(() {});
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: StageAppBar(
        background: const Color(0xFFF4F4F4),
        isBackButtonVisible: true,
        title: ref.watch(songNotifierProvider).song.title ?? '',
        trailing: _isSongNull() ? const SizedBox() : const SongAppBarLeading(),
      ),
      body: _isSongNull()
          ? const LoadingIndicator(indicatorType: Indicator.lineScale)
          : _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SongDetailWidget(
              widgetPadding: 64,
              lyrics: ref.watch(songNotifierProvider).song.lyrics ?? '',
              onTapChord: () {},
            ),
          ],
        ),
      ),
    );
  }

  bool _isSongNull() =>
      ref.watch(songNotifierProvider).song.id.isNullEmptyOrWhitespace;
}
