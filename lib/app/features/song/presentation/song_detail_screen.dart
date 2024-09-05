import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_detail_shimmer_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  const SongDetailScreen(
    this.songId, {
    super.key,
  });

  final String songId;

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songNotifierProvider.notifier).init(widget.songId);
    });
    super.initState();
  }

  bool _isSongNull() =>
      ref.watch(songNotifierProvider).song.id.isNullEmptyOrWhitespace ||
      ref.watch(songNotifierProvider).isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: StageAppBar(
        background: const Color(0xFFF4F4F4),
        isBackButtonVisible: true,
        title: ref.watch(songNotifierProvider).song.title ?? '',
        trailing: const SongAppBarLeading(),
      ),
      body: _isSongNull() ? const SongDetailShimmerWidget() : _buildBody(),
    );
  }
}

Widget _buildBody() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SongDetailWidget(
            widgetPadding: 64,
            onTapChord: () {},
          ),
        ],
      ),
    ),
  );
}
//TODO: Last page is not working
//TODO: I think we can create a new wrapper widget which will handle the pagination, not dealing with singleId widget
