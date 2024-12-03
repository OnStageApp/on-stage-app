import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.85,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(
          title: 'Select a Theme',
        ),
        headerHeight: () => 64,
        footerHeight: () => 64,
        buildContent: () => ThemeModal(onSelected: onSelected),
      ),
    );
  }
}

class ThemeModalState extends ConsumerState<ThemeModal> {
  final List<ThemeEnum> _allThemes = ThemesDummy.themes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _allThemes.length,
            itemBuilder: (context, index) {
              return _buildTile(_allThemes[index]);
            },
          ),
        ],
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
                  theme.name.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  theme.name,
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
