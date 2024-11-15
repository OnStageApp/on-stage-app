import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  const SongDetailScreen({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  SongDetailScreenState createState() => SongDetailScreenState();
}

class SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songNotifierProvider.notifier).init(widget.songId);
    });
  }

  bool _isSongNull() =>
      ref.watch(songNotifierProvider).song.id.isNullEmptyOrWhitespace ||
      ref.watch(songNotifierProvider).isLoading ||
      ref.watch(songNotifierProvider).processingSong == true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: StageAppBar(
        background: context.colorScheme.surface,
        isBackButtonVisible: true,
        title: ref.watch(songNotifierProvider).song.title ?? '',
        trailing: const SongAppBarLeading(),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: EditableStructureList(),
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _isSongNull()
            ? const SizedBox()
            : SongDetailWidget(
                widgetPadding: 64,
                onTapChord: () {},
              ),
      ),
    );
  }
}
