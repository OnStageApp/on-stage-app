import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageSearchBar extends StatelessWidget {
  const StageSearchBar({
    required this.focusNode,
    this.controller,
    this.onChanged,
    this.onClosed,
    super.key,
  });

  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onClosed;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 300);
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      shadowColor: MaterialStateColor.resolveWith(
        (states) => Colors.transparent,
      ),
      overlayColor: MaterialStateColor.resolveWith(
        (states) => Colors.transparent,
      ),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => context.colorScheme.surfaceVariant,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: AnimatedOpacity(
          opacity: focusNode.hasFocus ? 1 : 0.7,
          duration: animationDuration,
          child: Icon(
            Icons.search,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      trailing: [
        AnimatedOpacity(
          opacity: focusNode.hasFocus ? 1 : 0,
          duration: animationDuration,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: context.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              focusNode.unfocus();
              controller?.clear();
              onClosed?.call();
            },
          ),
        ),
      ],
      hintText: 'Search',
      onChanged: onChanged,
    );
  }
}
