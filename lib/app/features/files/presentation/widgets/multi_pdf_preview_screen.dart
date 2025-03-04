import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/pdf_preview_widget.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiPdfPreviewDialog extends StatefulWidget {
  const MultiPdfPreviewDialog({
    required this.filePaths,
    required this.initialIndex,
    super.key,
  });
  final List<String> filePaths;
  final int initialIndex;

  static Future<void> show({
    required BuildContext context,
    required List<String> filePaths,
    int initialIndex = 0,
  }) {
    return AdaptiveModal.show<void>(
      context: context,
      enableDrag: false,
      child: MultiPdfPreviewDialog(
        filePaths: filePaths,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  MultiPdfPreviewDialogState createState() => MultiPdfPreviewDialogState();
}

class MultiPdfPreviewDialogState extends State<MultiPdfPreviewDialog> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.filePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(),
                    child: PdfViewerScreen(
                      filePath: widget.filePaths[index],
                    ),
                  );
                },
              ),
              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.surface,
                    ),
                    child: Icon(
                      Icons.close,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Page indicator
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.filePaths.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
