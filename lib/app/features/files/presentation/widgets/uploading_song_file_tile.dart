import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/files/domain/uploading_file.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

enum UploadStatus { uploading, success, error }

class UploadingSongFileTile extends StatefulWidget {
  const UploadingSongFileTile({
    required this.songFile,
    this.status = UploadStatus.uploading,
    this.errorMessage,
    this.onCanceled,
    super.key,
  });

  final UploadingFile songFile;
  final UploadStatus status;
  final String? errorMessage;
  final VoidCallback? onCanceled;

  @override
  State<UploadingSongFileTile> createState() => _UploadingSongFileTileState();
}

class _UploadingSongFileTileState extends State<UploadingSongFileTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create opacity animation that peaks in the middle then fades out
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0.3),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 0),
        weight: 25,
      ),
    ]).animate(_animationController);

    if (widget.status == UploadStatus.success) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(UploadingSongFileTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status &&
        widget.status == UploadStatus.success) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              // Green overlay when upload succeeds
              if (widget.status == UploadStatus.success)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.green.withOpacity(_opacityAnimation.value),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildFileIcon(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songFile.name,
                      style: context.textTheme.titleMedium!.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _getFileSize(),
                          style: context.textTheme.bodySmall!.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusText(context),
                      ],
                    ),
                    if (widget.status != UploadStatus.success) ...[
                      const SizedBox(height: 8),
                      _buildIndicator(context),
                    ] else ...[
                      const SizedBox(height: 12),
                    ],
                    if (widget.status == UploadStatus.error &&
                        widget.errorMessage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.errorMessage!,
                        style: context.textTheme.bodySmall!.copyWith(
                          color: context.colorScheme.error,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              _buildActionWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(BuildContext context) {
    final icon = Icon(
      widget.songFile.fileType.icon,
      size: 24,
      color: _getIconColor(),
    );

    if (widget.status == UploadStatus.uploading) {
      return Shimmer.fromColors(
        baseColor: widget.songFile.fileType.iconColor().withAlpha(180),
        highlightColor: widget.songFile.fileType.iconColor(),
        period: const Duration(seconds: 1),
        child: icon,
      );
    }

    return icon;
  }

  Color _getIconColor() {
    switch (widget.status) {
      case UploadStatus.uploading:
        return widget.songFile.fileType.iconColor();
      case UploadStatus.success:
        return Colors.green;
      case UploadStatus.error:
        return context.colorScheme.error;
    }
  }

  Widget _buildStatusText(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (widget.status) {
      case UploadStatus.uploading:
        statusText = '• Uploading';
        statusColor = context.colorScheme.primary;
      case UploadStatus.success:
        statusText = '• Upload complete';
        statusColor = Colors.green;
      case UploadStatus.error:
        statusText = '• Upload failed';
        statusColor = context.colorScheme.error;
    }

    return Text(
      statusText,
      style: context.textTheme.bodySmall!.copyWith(
        color: statusColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    if (widget.status == UploadStatus.error) {
      return Container(
        height: 4,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Row(
          children: [
            SizedBox(
              height: 4,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          backgroundColor: context.colorScheme.surfaceContainerHighest,
          color: context.colorScheme.primary,
          minHeight: 4,
        ),
      ),
    );
  }

  Widget _buildActionWidget(BuildContext context) {
    switch (widget.status) {
      case UploadStatus.uploading:
        return const SizedBox.shrink();
      case UploadStatus.success:
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 18,
            ),
          ),
        );

      case UploadStatus.error:
        return IconButton(
          icon: Icon(
            Icons.close,
            color: context.colorScheme.outline,
          ),
          iconSize: 20,
          onPressed: widget.onCanceled,
        );
    }
  }

  String _getFileSize() {
    final size = widget.songFile.size;
    const kb = 1024;
    const mb = kb * 1024;

    if (size < kb) {
      return '$size B';
    } else if (size < mb) {
      return '${(size / kb).toStringAsFixed(2)} KB';
    } else {
      return '${(size / mb).toStringAsFixed(2)} MB';
    }
  }
}
