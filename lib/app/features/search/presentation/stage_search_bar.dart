import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_provider.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class StageSearchBar extends ConsumerStatefulWidget {
  const StageSearchBar({
    this.controller,
    this.onChanged,
    this.onClosed,
    this.onTap,
    this.hasToFocus = false,
    super.key,
  });

  final void Function(String)? onChanged;
  final void Function()? onClosed;
  final void Function()? onTap;
  final bool hasToFocus;

  final TextEditingController? controller;

  @override
  ConsumerState<StageSearchBar> createState() => _StageSearchBarState();
}

class _StageSearchBarState extends ConsumerState<StageSearchBar> {
  Timer? _debounce;
  late final TextEditingController _internalController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_onSearchChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return; // Check if the widget is still mounted
      final text = _internalController.text;
      ref.read(searchNotifierProvider.notifier).setText(text);
      widget.onChanged?.call(text);
    });
  }

  void _onFocusChange() {
    ref.read(searchNotifierProvider.notifier).setFocus(
          isFocused: _focusNode.hasFocus,
        );
  }

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 300);

    return SizedBox(
      height: Insets.extraLarge,
      child: SearchBar(
        controller: _internalController,
        focusNode: _focusNode,
        shadowColor:
            WidgetStateProperty.resolveWith((states) => Colors.transparent),
        overlayColor:
            WidgetStateProperty.resolveWith((states) => Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => const Color(0xFFE2E2E5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Assets.icons.search.svg(),
        ),
        trailing: [
          AnimatedOpacity(
            opacity: ref.read(searchNotifierProvider).isFocused ? 1 : 0,
            duration: animationDuration,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: context.colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                _focusNode.unfocus();
                _internalController.clear();
                ref.read(searchNotifierProvider.notifier).clear();
                widget.onClosed?.call();
              },
            ),
          ),
        ],
        hintText: 'Search',
        hintStyle: WidgetStateProperty.all(
          context.textTheme.titleLarge!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        onChanged: (value) => _onSearchChanged(),
        onTap: () {
          widget.onTap?.call();
        },
      ),
    );
  }
}
