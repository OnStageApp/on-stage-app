import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DraggableFilesOverlay extends StatefulWidget {
  const DraggableFilesOverlay({
    required this.child,
    required this.onFileDropped,
    super.key,
  });

  final Widget child;
  final void Function(PlatformFile file) onFileDropped;

  @override
  State<DraggableFilesOverlay> createState() => _DraggableFilesOverlayState();
}

class _DraggableFilesOverlayState extends State<DraggableFilesOverlay> {
  static const _supportedFormats = {
    'm4a-audio': '.m4a',
    'mp3': '.mp3',
    'wav': '.wav',
    'aac': '.aac',
    // Document formats
    'pdf': '.pdf',
    'doc': '.doc',
    'docx': '.docx',
    'ppt': '.ppt',
    'pptx': '.pptx',
    'text': '.txt',
  };

  static const _supportedStandardFormats = [
    Formats.pdf as DataFormat,
    Formats.plainText as DataFormat,
    Formats.wav as DataFormat,
    Formats.mp3 as DataFormat,
    Formats.m4a as DataFormat,
    Formats.aac as DataFormat,
    Formats.ppt as DataFormat,
    Formats.doc as DataFormat,
    Formats.docx as DataFormat,
    Formats.pptx as DataFormat,
  ];

  bool _isDragging = false;

  String _getFileExtension(DropItem item, String? suggestedName) {
    // If we have a suggested name with an extension, don't add another one
    if (suggestedName != null) {
      final lowercaseName = suggestedName.toLowerCase();
      if (_supportedFormats.values.any(
        lowercaseName.endsWith,
      )) {
        return '';
      }
    }

    // Check platform-specific formats first
    final platformFormat = item.platformFormats.firstOrNull?.toString();
    if (platformFormat != null) {
      for (final format in _supportedFormats.keys) {
        if (platformFormat.contains(format)) {
          return _supportedFormats[format]!;
        }
      }
    }

    // Then check standard formats
    for (final format in _supportedStandardFormats) {
      if (item.canProvide(format)) {
        // Map standard format to extension
        final formatStr = format.toString().toLowerCase();
        for (final entry in _supportedFormats.entries) {
          if (formatStr.contains(entry.key)) {
            return entry.value;
          }
        }
      }
    }

    return '';
  }

  bool _isSupported(DropItem item) {
    // Check platform-specific formats
    final hasSupported = item.platformFormats.any((format) {
      final formatStr = format.toLowerCase();
      return _supportedFormats.keys.any(
        formatStr.contains,
      );
    });

    if (hasSupported) return true;

    // Check standard formats
    return _supportedStandardFormats.any(item.canProvide);
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      onDropOver: (event) {
        final item = event.session.items.first;
        logger.i('Event formats: ${item.platformFormats}');

        if (_isSupported(item) && !_isDragging) {
          setState(() => _isDragging = true);
        }
        return DropOperation.copy;
      },
      onDropLeave: (event) {
        setState(() => _isDragging = false);
      },
      onPerformDrop: (event) async {
        setState(() => _isDragging = false);
        final item = event.session.items.first;

        if (_isSupported(item)) {
          final reader = item.dataReader;
          if (reader != null) {
            try {
              final suggestedName = await reader.getSuggestedName();
              logger.i('Suggested name: $suggestedName');

              reader.getFile(null, (file) async {
                try {
                  final fileData = await file.readAll();
                  final platformFile = PlatformFile(
                    name:
                        '$suggestedName${_getFileExtension(item, suggestedName)}',
                    size: fileData.length,
                    bytes: fileData,
                  );
                  widget.onFileDropped(platformFile);
                } catch (e) {
                  logger.e('Error reading dropped file: $e');
                }
              });
            } catch (e) {
              logger.e('Error processing dropped file: $e');
            }
          }
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_isDragging)
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ColoredBox(
                color: Colors.black.withAlpha(100),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.cloud_upload,
                          size: 42,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Drag and drop files here',
                          style: context.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
