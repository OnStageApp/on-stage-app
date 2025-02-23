import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/files/presentation/widgets/pdf_preview_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiPdfPreviewScreen extends StatefulWidget {
  const MultiPdfPreviewScreen({
    required this.filePaths,
    required this.initialIndex,
    super.key,
  });
  final List<String> filePaths;
  final int initialIndex;

  @override
  MultiPdfPreviewScreenState createState() => MultiPdfPreviewScreenState();
}

class MultiPdfPreviewScreenState extends State<MultiPdfPreviewScreen> {
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
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: '',
        titleWidget: Text(
          'Files',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.filePaths.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PdfViewerScreen(filePath: widget.filePaths[index]),
                ),
              );
            },
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.filePaths.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
