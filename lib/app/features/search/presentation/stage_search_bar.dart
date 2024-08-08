import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
import 'package:on_stage_app/app/features/song/presentation/song_filter_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/list_utils.dart';

class StageSearchBar extends ConsumerStatefulWidget {
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
  ConsumerState<StageSearchBar> createState() => _StageSearchBarState();
}

class _StageSearchBarState extends ConsumerState<StageSearchBar> {
  Timer? _debounce;
  late final TextEditingController _internalController;

  var _isFilteringActive = false;

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
      widget.onChanged?.call(_internalController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    _isFilteringActive = ref
        .watch(searchControllerProvider.notifier)
        .getAllFilters()
        .isNotNullOrEmpty;
    const animationDuration = Duration(milliseconds: 300);
    return Column(
      children: [
        SearchBar(
          constraints: const BoxConstraints(maxHeight: 44),
          controller: _internalController,
          focusNode: widget.focusNode,
          shadowColor:
              WidgetStateProperty.resolveWith((states) => Colors.transparent),
          overlayColor:
              WidgetStateProperty.resolveWith((states) => Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => context.colorScheme.surfaceBright,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: _isFilteringActive
                  ? const BorderRadius.vertical(
                      top: Radius.circular(12),
                    )
                  : BorderRadius.circular(12),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AnimatedOpacity(
              opacity: widget.focusNode.hasFocus ? 1 : 0.7,
              duration: animationDuration,
              child: Icon(
                Icons.search_rounded,
                color: context.colorScheme.outline,
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
                  color: context.colorScheme.outline,
                ),
                onPressed: () {
                  widget.focusNode.unfocus();
                  _internalController.clear();
                  widget.onClosed?.call();
                },
              ),
            ),
            if (widget.showFilterButton)
              Container(
                height: 28,
                width: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _isFilteringActive
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                ),
                child: InkWell(
                  onTap: () {
                    SongFilterModal.show(context: context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.filter_list,
                        color: _isFilteringActive
                            ? context.colorScheme.onSurfaceVariant
                            : context.colorScheme.onSurface,
                        size: 15,
                      ),
                      Text(
                        'Filter',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: _isFilteringActive
                                      ? context.colorScheme.onSurfaceVariant
                                      : context.colorScheme.onSurface,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          hintText: 'Search',
          hintStyle: WidgetStateProperty.all(
            context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          onChanged: (value) => _onSearchChanged(),
          onTap: widget.onTap,
        ),
        if (_isFilteringActive)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceBright,
              border: const Border(
                top: BorderSide(
                  color: Color(0xFFD5D5D9),
                ),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Wrap(
              children: List.generate(
                  ref
                      .watch(searchControllerProvider.notifier)
                      .getAllFilters()
                      .length, (index) {
                final filter = ref
                    .watch(searchControllerProvider.notifier)
                    .getAllFilters()[index];
                if (filter != null) {
                  return IntrinsicWidth(
                    child: _buildAddedFilter(filter),
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildAddedFilter(SearchFilter filter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filter.type.title,
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.surfaceDim),
          ),
          const SizedBox(width: 6),
          Text(filter.value, style: context.textTheme.titleMedium),
          const SizedBox(width: 6),
          SvgPicture.asset(
            'assets/icons/close-icon.svg',
            color: context.colorScheme.surfaceDim,
          ),
        ],
      ),
    );
  }
}
