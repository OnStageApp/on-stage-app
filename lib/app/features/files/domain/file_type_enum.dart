import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

enum FileTypeEnum {
  audio,
  pdf,
  other,
}

extension FileTypeExtension on FileTypeEnum {
  IconData get icon {
    switch (this) {
      case FileTypeEnum.audio:
        return LucideIcons.chart_no_axes_column;
      case FileTypeEnum.pdf:
        return LucideIcons.file_text;
      case FileTypeEnum.other:
        return LucideIcons.sticky_note;
    }
  }

  Color iconColor() {
    switch (this) {
      case FileTypeEnum.audio:
        return const Color(0xFFADEBFF);
      case FileTypeEnum.pdf:
        return const Color(0xFF9FC6FF);
      case FileTypeEnum.other:
        return Colors.grey;
    }
  }
}
