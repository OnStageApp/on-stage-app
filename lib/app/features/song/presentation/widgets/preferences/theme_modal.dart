import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ThemeModal extends ConsumerStatefulWidget {
  const ThemeModal({super.key});

  @override
  ThemeModalState createState() => ThemeModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F4F4),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(
          title: 'Select a Theme',
        ),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: ThemeModal.new,
      ),
    );
  }
}

class ThemeModalState extends ConsumerState<ThemeModal> {
  final List<ThemeFilterEnum> _allThemes = ThemesDummy.themes;

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

  InkWell _buildTile(ThemeFilterEnum theme) {
    return InkWell(
      onTap: () {
        ref.read(searchControllerProvider.notifier).setThemeFilter(
              _isItemSelected(theme) ? null : theme,
            );
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(bottom: 8),
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
              key: ValueKey(
                theme.hashCode.toString(),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                theme.name.substring(0, 1),
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall,
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
    );
  }

  bool _isItemSelected(ThemeFilterEnum theme) =>
      ref.watch(searchControllerProvider).themeFilter == theme;
}
