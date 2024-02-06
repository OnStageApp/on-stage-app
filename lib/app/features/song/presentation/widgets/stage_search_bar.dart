import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageSearchBar extends StatefulWidget {
  const StageSearchBar({
    required this.focusNode,
    this.controller,
    this.onChanged,
    this.onClosed,
    this.onTap,
    super.key,
  });

  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onClosed;
  final void Function()? onTap;

  final TextEditingController? controller;

  @override
  State<StageSearchBar> createState() => _StageSearchBarState();
}

class _StageSearchBarState extends State<StageSearchBar> {
  Timer? _debounce;
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();

    _internalController.addListener(_onSearchChanged);
  }

  @override
  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Call widget.onChanged with the debounced text input
      widget.onChanged?.call(_internalController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 300);
    return SearchBar(
      controller: _internalController,
      focusNode: widget.focusNode,
      shadowColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
      overlayColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => context.colorScheme.surfaceVariant,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: AnimatedOpacity(
          opacity: widget.focusNode.hasFocus ? 1 : 0.7,
          duration: animationDuration,
          child: Icon(
            Icons.search,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      trailing: [
        AnimatedOpacity(
          opacity: widget.focusNode.hasFocus ? 1 : 0,
          duration: animationDuration,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: context.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              widget.focusNode.unfocus();
              _internalController.clear();
              widget.onClosed?.call();
            },
          ),
        ),
      ],
      hintText: 'Search',
      onChanged: (value) => _onSearchChanged(),
      onTap: widget.onTap,
    );
  }
}
