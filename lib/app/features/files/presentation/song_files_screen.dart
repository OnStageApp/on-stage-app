import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/application/upload_manager/uploads_manager.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/draggable_area.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/file_section.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_empty_widget.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_shimmer.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/uploading_section.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/beta_label_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/supported_file_formats/supported_file_formats.dart';
import 'package:on_stage_app/logger.dart';

class SongFilesScreen extends ConsumerStatefulWidget {
  const SongFilesScreen(
    this.songId, {
    super.key,
  });
  final String songId;

  @override
  SongFilesScreenState createState() => SongFilesScreenState();
}

class SongFilesScreenState extends ConsumerState<SongFilesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFiles();
    });
  }

  Future<void> _loadFiles() async {
    await ref
        .read(songFilesNotifierProvider.notifier)
        .getSongFiles(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    final filesState = ref.watch(songFilesNotifierProvider);
    final isLoading = filesState.isLoading;
    final error = filesState.error;
    final files = filesState.songFiles;

    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: '',
          titleWidget: const Row(
            children: [
              Text('Files'),
              SizedBox(width: 12),
              BetaLabelWidget(),
            ],
          ),
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AddNewButton(
              onPressed: isLoading ? null : pickFile,
            ),
          ),
        ),
        body: DraggableFilesOverlay(
          onFileDropped: isLoading ? (p) {} : onFileDropped,
          child: RefreshIndicator.adaptive(
            onRefresh: _loadFiles,
            child: _buildContent(isLoading, error, files),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isLoading, Object? error, List<SongFile> files) {
    final uploadingFiles = ref.watch(uploadsManagerProvider).uploadingFiles;
    if (isLoading && files.isEmpty) {
      return const SongFileShimmerList();
    }

    if (error != null && files.isEmpty) {
      return _buildErrorState();
    }

    if (files.isEmpty && uploadingFiles.isEmpty) {
      return const SongFileEmptyWidget();
    }

    return _buildFilesList(files);
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load files',
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'An error occurred while loading files. Please try again.',
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(LucideIcons.refresh_cw),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilesList(List<SongFile> files) {
    final audioFiles =
        files.where((file) => file.fileType == FileTypeEnum.audio).toList();
    final documentFiles =
        files.where((file) => file.fileType == FileTypeEnum.pdf).toList();
    final otherFiles =
        files.where((file) => file.fileType == FileTypeEnum.other).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          UploadingSection(
            songId: widget.songId,
          ),
          if (audioFiles.isNotEmpty)
            FileSection(
              title: 'Audio',
              files: audioFiles,
              songId: widget.songId,
            ),
          if (documentFiles.isNotEmpty)
            FileSection(
              title: 'Documents',
              files: documentFiles,
              songId: widget.songId,
            ),
          if (otherFiles.isNotEmpty)
            FileSection(
              title: 'Other',
              files: otherFiles,
              songId: widget.songId,
            ),
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: SupportedFileFormats.allowedExtensions,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      final notifier = ref.read(songFilesNotifierProvider.notifier);

      final uploadFutures = result.files.map((file) async {
        try {
          await notifier.uploadFile(file, widget.songId);
        } catch (e) {
          if (mounted) {
            _showUploadError(file.name, e);
          }
        }
      }).toList();

      await Future.wait(uploadFutures);
    } catch (e) {
      logger.e('Error picking file: $e');
    }
  }

  Future<void> onFileDropped(PlatformFile platformFile) async {
    try {
      logger.i('Uploading file: ${platformFile.name}');
      await ref
          .read(songFilesNotifierProvider.notifier)
          .uploadDroppedFile(platformFile, widget.songId);
    } catch (e) {
      if (mounted) {
        _showUploadError(platformFile.name, e);
      }
    }
  }

  void _showUploadError(String fileName, Object error) {
    AdaptiveDialog.show(
      context: context,
      title: 'Upload Failed',
      description: 'Failed to upload "$fileName". Would you like to try again?',
      actionText: 'Retry',
      onAction: () {},
    );
  }
}
