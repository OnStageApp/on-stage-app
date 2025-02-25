import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/file_type_enum.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/draggable_area.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/file_section.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/song_file_empty_widget.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/upload_section_widget.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
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
          title: 'Files',
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            // Disable button while loading
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
    // Show loading state
    if (isLoading && files.isEmpty) {
      return _buildLoadingState();
    }

    // Show error state
    if (error != null && files.isEmpty) {
      return _buildErrorState(error);
    }

    // Show empty state
    if (files.isEmpty) {
      return const SongFileEmptyWidget();
    }

    // Show file list
    return _buildFilesList(files);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Loading files...',
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
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
              error.toString(),
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadFiles,
              icon: const Icon(Icons.refresh),
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
          // Show if all sections are empty
          if (audioFiles.isEmpty && documentFiles.isEmpty && otherFiles.isEmpty)
            const SongFileEmptyWidget(),
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      if (mounted) {
        // TopFlushBar.show(
        //   context,
        //   'Uploading files...',
        //   icon: Icons.cloud_upload_outlined,
        //   backgroundColor: context.colorScheme.surface,
        // );
      }

      final notifier = ref.read(songFilesNotifierProvider.notifier);

      // Upload files one by one
      for (final file in result.files) {
        try {
          await notifier.uploadFile(file, widget.songId);
        } catch (e) {
          if (mounted) {
            _showUploadError(file.name, e);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        // TopFlushBar.show(
        //   context,
        //   'Error selecting files: $e',
        //   icon: Icons.error_outline,
        //   isError: true,
        // );
      }
    }
  }

  Future<void> onFileDropped(PlatformFile platformFile) async {
    try {
      // Show uploading message
      if (mounted) {
        // TopFlushBar.show(
        //   context,
        //   'Uploading ${platformFile.name}...',
        //   icon: Icons.cloud_upload_outlined,
        // );
      }

      await ref
          .read(songFilesNotifierProvider.notifier)
          .uploadFile(platformFile, widget.songId);
    } catch (e) {
      if (mounted) {
        _showUploadError(platformFile.name, e);
      }
    }
  }

  void _showUploadError(String fileName, Object error) {
    // Use AdaptiveDialog for errors that can be retried
    AdaptiveDialog.show(
      context: context,
      title: 'Upload Failed',
      description: 'Failed to upload "$fileName". Would you like to try again?',
      actionText: 'Retry',
      onAction: () {
        // Show error details
        // TopFlushBar.show(
        //   context,
        //   'Error: $error',
        //   icon: Icons.error_outline,
        //   isError: true,
        // );
      },
    );
  }

  static const List<String> _allowedExtensions = [
    // Audio files
    'mp3', 'wav', 'aac', 'm4a', 'caf', 'flac', 'ogg',
    // Document files
    'pdf', 'doc', 'docx', 'txt', 'rtf', 'md',
    // Presentation files
    'ppt', 'pptx',
    // Image files
    'jpg', 'jpeg', 'png', 'gif', 'webp',
  ];
}
