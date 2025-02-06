import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class ThemeModal extends ConsumerStatefulWidget {
  const ThemeModal({
    required this.onSelected,
    super.key,
  });

  final void Function(ThemeEnum?) onSelected;

  @override
  ThemeModalState createState() => ThemeModalState();

  static void show({
    required BuildContext context,
    required void Function(ThemeEnum?) onSelected,
  }) {
    AdaptiveModal.show(
      context: context,
      child: ThemeModal(onSelected: onSelected),
    );
  }
}

class ThemeModalState extends ConsumerState<ThemeModal> {
  final List<ThemeEnum> _allThemes = ThemesDummy.themes;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<ThemeEnum> _filteredThemes = [];

  @override
  void initState() {
    super.initState();
    _filteredThemes = _allThemes;
    _searchController.addListener(_filterThemes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterThemes);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterThemes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredThemes = _allThemes
          .where((theme) => theme.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => const ModalHeader(
        title: 'Select a Theme',
      ),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            StageSearchBar(
              focusNode: _focusNode,
              controller: _searchController,
              onChanged: (value) => _filterThemes(),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _filteredThemes.length,
              itemBuilder: (context, index) {
                return _buildTile(_filteredThemes[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ThemeEnum theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          final newTheme = _isItemSelected(theme) ? null : theme;
          widget.onSelected(newTheme);
          if (context.mounted) {
            context.popDialog();
          }
        },
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isItemSelected(theme)
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurfaceVariant,
              width: 1.6,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                key: ValueKey(theme.hashCode.toString()),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  border: Border.all(
                    color: Colors.green,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  theme.title.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  theme.title,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isItemSelected(ThemeEnum theme) =>
      ref.watch(searchNotifierProvider).themeFilter == theme;
}
