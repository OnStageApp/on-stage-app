import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_tile.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongFilesScreen extends ConsumerStatefulWidget {
  const SongFilesScreen({super.key});

  @override
  SongFilesScreenState createState() => SongFilesScreenState();
}

class SongFilesScreenState extends ConsumerState<SongFilesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songFilesNotifierProvider.notifier).getSongFiles();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final files = ref.watch(songFilesNotifierProvider).songFiles;

    // Separate files into audio and documents
    final audioFiles =
        files.where((file) => file.fileType == FileTypeEnum.audio).toList();
    final documentFiles =
        files.where((file) => file.fileType == FileTypeEnum.document).toList();

    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: 'Files',
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AddNewButton(
              onPressed: pickFile,
            ),
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            await ref.read(songFilesNotifierProvider.notifier).getSongFiles();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                if (audioFiles.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Audio Files',
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: audioFiles.length,
                    itemBuilder: (context, index) {
                      return SongFileTile(
                        audioFiles[index],
                      );
                    },
                  ),
                ],
                // Document Files Section
                if (documentFiles.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Document Files',
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documentFiles.length,
                    itemBuilder: (context, index) {
                      return SongFileTile(
                        documentFiles[index],
                        // onTap: () {},
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        // Audio files
        'mp3', 'wav', 'aac', 'm4a', 'caf',
        // Document files
        'pdf', 'doc', 'docx', 'txt',
      ],
    );

    if (result != null) {
      final file = result.files.first;
      unawaited(ref.read(songFilesNotifierProvider.notifier).addSongFile(file));
    }
  }
}
