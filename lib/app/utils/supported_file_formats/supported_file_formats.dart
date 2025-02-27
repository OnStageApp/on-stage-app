import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class SupportedFileFormats {
  SupportedFileFormats._();

  static const Map<String, String> formatExtensionMap = {
    // Audio formats
    'm4a-audio': '.m4a',
    'mp3': '.mp3',
    'wav': '.wav',
    'aac': '.aac',
    'flac': '.flac',
    'ogg': '.ogg',
    'wma': '.wma',
    'aiff': '.aiff',
    'alac': '.alac',
    'opus': '.opus',
    'amr': '.amr',
    'mka': '.mka',
    'spx': '.spx',
    'ra': '.ra',
    'wavpack': '.wavpack',
    'pcm': '.pcm',
    'caf': '.caf',

    // Document formats
    'pdf': '.pdf',
    'doc': '.doc',
    'docx': '.docx',
    'text': '.txt',
    'rtf': '.rtf',
    'md': '.md',
    'pages': '.pages',

    // Presentation formats
    'ppt': '.ppt',
    'pptx': '.pptx',

    // Image formats
    'jpeg': '.jpg',
    'jpg': '.jpg',
    'png': '.png',
    'gif': '.gif',
    'webp': '.webp',
  };

  static List<String> get allowedExtensions => formatExtensionMap.values
      .map((ext) => ext.startsWith('.') ? ext.substring(1) : ext)
      .toList();

  static const List<DataFormat> supportedStandardFormats = [
    // Document formats
    Formats.pdf,
    Formats.plainText,
    Formats.rtf,
    Formats.doc,
    Formats.docx,

    // Presentation formats
    Formats.ppt,
    Formats.pptx,

    // Audio formats
    Formats.wav,
    Formats.mp3,
    Formats.m4a,
    Formats.aac,

    // Image formats
    Formats.jpeg,
    Formats.png,
    Formats.gif,
  ];

  static bool isExtensionSupported(String extension) {
    final ext = extension.startsWith('.') ? extension.substring(1) : extension;
    return allowedExtensions.contains(ext.toLowerCase());
  }

  static bool isFileSupported(String filename) {
    final lowercaseName = filename.toLowerCase();
    return formatExtensionMap.values.any(lowercaseName.endsWith);
  }
}
