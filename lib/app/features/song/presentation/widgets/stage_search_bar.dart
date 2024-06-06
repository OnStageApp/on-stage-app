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
    this.showFilterButton = false,
    super.key,
  });

  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onClosed;
  final void Function()? onTap;
  final bool showFilterButton;

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
      constraints: const BoxConstraints(maxHeight: 44),
      controller: _internalController,
      focusNode: widget.focusNode,
      shadowColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
      overlayColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => const Color(0xFFE2E2E5),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: AnimatedOpacity(
          opacity: widget.focusNode.hasFocus ? 1 : 0.7,
          duration: animationDuration,
          child: Icon(
            Icons.search_rounded,
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
        if (widget.showFilterButton) // Conditionally show the filter button
          Container(
            // constraints: BoxConstraints.expand(height: 8),
            height: 28,
            width: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: InkWell(
              onTap: () {
                AdvancedSongSearchModal.show(
                  context: context,
                  // tonality: ref.watch(songNotifierProvider).song.songKey!,
                );
              },
              child:  Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.filter_list,
                    color:  context.colorScheme.onSurfaceVariant,
                    size: 15,
                  ),
                  Text(
                    'Filter',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),


      ],
      hintText: 'Search',
      hintStyle: MaterialStateProperty.all(
        context.textTheme.titleMedium!.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      onChanged: (value) => _onSearchChanged(),
      onTap: widget.onTap,
    );
  }
}
