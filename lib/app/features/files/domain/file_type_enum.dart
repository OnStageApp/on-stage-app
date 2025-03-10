// lib/app/features/files/domain/file_type_enum.dart
// Add this method to the existing FileTypeEnum class

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum FileTypeEnum {
  link,
  audio,
  pdf,
  other;

  IconData get icon {
    switch (this) {
      case FileTypeEnum.link:
        return LucideIcons.link;
      case FileTypeEnum.audio:
        return LucideIcons.audio_lines;
      case FileTypeEnum.pdf:
        return LucideIcons.file_text;
      case FileTypeEnum.other:
        return LucideIcons.file;
    }
  }

  Color iconColor() {
    switch (this) {
      case FileTypeEnum.link:
        return Colors.blue;
      case FileTypeEnum.audio:
        return Colors.green;
      case FileTypeEnum.pdf:
        return Colors.red;
      case FileTypeEnum.other:
        return Colors.grey;
    }
  }

  // Add this static method to determine file type from extension
  static FileTypeEnum fromExtension(String extension) {
    final ext = extension.toLowerCase();

    if (['mp3', 'wav', 'aac', 'm4a', 'caf', 'flac', 'ogg'].contains(ext)) {
      return FileTypeEnum.audio;
    } else if (['pdf'].contains(ext)) {
      return FileTypeEnum.pdf;
    } else {
      return FileTypeEnum.other;
    }
  }
}
