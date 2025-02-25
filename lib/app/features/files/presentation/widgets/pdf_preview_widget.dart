import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_stage_app/logger.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({required this.filePath, super.key});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    return SizedBox(
      child: SfPdfViewer.file(
        file,
        scrollDirection: PdfScrollDirection.vertical,
        onDocumentLoaded: (details) {
          logger.i('PdfViewerScreen: Document loaded $details');
        },
        onDocumentLoadFailed: (details) {
          logger.e('PdfViewerScreen: Document load failed ${details.error}');
        },
      ),
    );
  }
}
