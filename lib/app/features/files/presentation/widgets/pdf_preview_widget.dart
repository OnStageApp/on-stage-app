import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({required this.filePath, super.key});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SfPdfViewer.file(
        File(filePath),
        scrollDirection: PdfScrollDirection.vertical,
        // By default, Syncfusion's PDF Viewer displays pages continuously.
      ),
    );
  }
}
