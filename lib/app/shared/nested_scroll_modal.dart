import 'package:flutter/material.dart';

typedef WidgetCallback = Widget Function();
typedef ContentCallback = Widget Function();
typedef SizeCallback = double Function();

class NestedScrollModal extends StatefulWidget {
  const NestedScrollModal({
    required this.buildContent,
    super.key,
    this.backgroundColor,
    this.buildHeader,
    this.headerHeight,
    this.buildFooter,
    this.footerHeight,
  });
  final Color? backgroundColor;
  final WidgetCallback? buildHeader;
  final SizeCallback? headerHeight;
  final WidgetCallback? buildFooter;
  final SizeCallback? footerHeight;
  final ContentCallback buildContent;

  @override
  State<NestedScrollModal> createState() => _NestedScrollModalState();
}

class _NestedScrollModalState extends State<NestedScrollModal> {
  final ScrollPhysics _physics = const ClampingScrollPhysics();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.buildHeader?.call();
    final headerSize = widget.headerHeight?.call();
    final footer = widget.buildFooter?.call();
    final footerSize = widget.footerHeight?.call();

    final hasHeader = header != null && headerSize != null;
    final hasFooter = footer != null && footerSize != null;
    final itemsCount = 1 + (hasHeader ? 1 : 0) + (hasFooter ? 1 : 0);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NotificationListener<ScrollStartNotification>(
            onNotification: (_) {
              return true;
            },
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemsCount,
                physics: _physics,
                itemBuilder: (context, index) {
                  if (hasHeader && index == 0) {
                    return Container(
                      color: Colors.transparent,
                      height: headerSize,
                    );
                  }

                  if (hasFooter && index == itemsCount - 1) {
                    return Container(
                      color: Colors.transparent,
                      height: footerSize,
                    );
                  }

                  return widget.buildContent();
                },
              ),
            ),
          ),
        ),
        if (hasHeader)
          Positioned(
            top: 0,
            child: header,
          ),
        if (hasFooter)
          Positioned(
            bottom: 0,
            child: footer,
          ),
      ],
    );
  }
}
