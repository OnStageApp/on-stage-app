import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/genres_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GenreModal extends ConsumerStatefulWidget {
  const GenreModal({
    required this.onSelected,
    super.key,
  });

  final void Function(GenreEnum?) onSelected;

  @override
  GenreModalState createState() => GenreModalState();

  static void show({
    required BuildContext context,
    required void Function(GenreEnum?) onSelected,
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
          title: 'Select a Genre',
        ),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: () {
          return GenreModal(onSelected: onSelected);
        },
      ),
    );
  }
}

class GenreModalState extends ConsumerState<GenreModal> {
  final List<GenreEnum> _allGenres = GenresDummy.genres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allGenres.length,
            itemBuilder: (context, index) {
              return _buildTile(_allGenres[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile(GenreEnum genre) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          final newGenre = _isItemSelected(genre) ? null : genre;
          widget.onSelected(newGenre);
        },
        overlayColor:
            WidgetStateProperty.all(context.colorScheme.surfaceBright),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isItemSelected(genre)
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
                key: ValueKey(genre.hashCode.toString()),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  border: Border.all(
                    color: context.colorScheme.primary,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  genre.title.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall!
                      .copyWith(color: context.colorScheme.onSurface),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  genre.title,
                  style: context.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isItemSelected(GenreEnum genre) =>
      ref.watch(searchNotifierProvider).genreFilter == genre;
}
