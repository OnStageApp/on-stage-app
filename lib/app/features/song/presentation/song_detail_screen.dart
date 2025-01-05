import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/editable_structure_list.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/song_app_bar_leading.dart';
import 'package:on_stage_app/app/router/app_router.dart';
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
      ref.read(songNotifierProvider.notifier).getSongById(widget.songId);
    });
  }

  bool _isSongNull() =>
      ref.watch(songNotifierProvider).song.id.isNullEmptyOrWhitespace ||
      ref.watch(songNotifierProvider).isLoading ||
      ref.watch(songNotifierProvider).processingSong == true;

  bool _isSongEmpty() =>
      ref.watch(songNotifierProvider).song.rawSections?.isEmpty ?? true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StageAppBar(
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
            : _isSongEmpty()
                ? _buildEmptySections()
                : SongDetailWidget(
                    widgetPadding: 64,
                    onTapChord: (chord) {},
                  ),
      ),
    );
  }

  Widget _buildEmptySections() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 64),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'No content added yet',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.surfaceDim,
                  ),
                ),
                if (ref.watch(permissionServiceProvider).hasAccessToEdit)
                  TextSpan(
                    text: ', add now.',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.pushNamed(
                          AppRoute.editSongContent.name,
                          queryParameters: {
                            'songId': ref.watch(songNotifierProvider).song.id,
                          },
                        );
                      },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
