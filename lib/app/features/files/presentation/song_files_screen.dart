import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/draggable_area.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_tile.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongFilesScreen extends ConsumerStatefulWidget {
  const SongFilesScreen(this.songId, {super.key});
  final String songId;

  @override
  SongFilesScreenState createState() => SongFilesScreenState();
}

class SongFilesScreenState extends ConsumerState<SongFilesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songFilesNotifierProvider.notifier).getSongFiles(widget.songId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final files = ref.watch(songFilesNotifierProvider).songFiles;

    final audioFiles =
        files.where((file) => file.fileType == FileTypeEnum.audio).toList();
    final documentFiles =
        files.where((file) => file.fileType == FileTypeEnum.pdf).toList();
    final otherFiles =
        files.where((file) => file.fileType == FileTypeEnum.other).toList();

    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: 'Files',
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AddNewButton(onPressed: pickFile),
          ),
        ),
        body: DraggableFilesOverlay(
          onFileDropped: (platformFile) {
            unawaited(
              ref
                  .read(songFilesNotifierProvider.notifier)
                  .addSongFile(platformFile),
            );
          },
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await ref
                  .read(songFilesNotifierProvider.notifier)
                  .getSongFiles(widget.songId);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                children: [
                  _buildFileSection('Audio', audioFiles),
                  _buildFileSection('PDFs', documentFiles),
                  _buildFileSection('Others', otherFiles),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileSection(String title, List<SongFile> files) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: context.textTheme.titleSmall,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) =>
              SongFileTile(files[index], widget.songId),
        ),
      ],
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'wav',
        'aac',
        'm4a',
        'caf',
        'pdf',
        'doc',
        'docx',
        'txt',
        'ppt',
        'pptx',
      ],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    await ref
        .read(songFilesNotifierProvider.notifier)
        .uploadFile(file, widget.songId);
  }
}
