import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/application/upload_manager/uploads_manager.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/uploading_song_file_tile.dart';

class UploadingSection extends ConsumerStatefulWidget {
  const UploadingSection({
    required this.songId,
    super.key,
  });

  final String songId;

  @override
  ConsumerState<UploadingSection> createState() => _UploadingSectionState();
}

class _UploadingSectionState extends ConsumerState<UploadingSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadingFiles = ref.watch(uploadsManagerProvider).uploadingFiles;
    final successFiles = ref.watch(uploadsManagerProvider).successFiles;
    final errorFiles = ref.watch(uploadsManagerProvider).errorFiles;

    final hasFiles = uploadingFiles.isNotEmpty ||
        successFiles.isNotEmpty ||
        errorFiles.isNotEmpty;

    // Manage animation based on visibility
    if (hasFiles && !_wasVisible) {
      _animationController.forward();
      _wasVisible = true;
    } else if (!hasFiles && _wasVisible) {
      _animationController.reverse();
      _wasVisible = false;
    }

    // Return an invisible widget if no files and fully collapsed
    if (!hasFiles && _animationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _heightAnimation,
          axisAlignment: -1, // Animate from top
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Uploading Files',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...uploadingFiles.map(
            (file) => UploadingSongFileTile(
              songFile: file,
            ),
          ),
          ...successFiles.map(
            (file) => UploadingSongFileTile(
              songFile: file,
              status: UploadStatus.success,
            ),
          ),
          ...errorFiles.map(
            (fileError) => UploadingSongFileTile(
              songFile: fileError.file,
              status: UploadStatus.error,
              errorMessage: fileError.errorMessage,
              onCanceled: () {
                ref
                    .read(uploadsManagerProvider.notifier)
                    .clearErrorFile(fileError.file.id);
                ref
                    .read(uploadsManagerProvider.notifier)
                    .cancelUpload(fileError.file.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
