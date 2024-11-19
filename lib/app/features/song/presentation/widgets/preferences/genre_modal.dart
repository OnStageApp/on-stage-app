import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/genres_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class GenreModal extends ConsumerStatefulWidget {
  const GenreModal({super.key});

  @override
  GenreModalState createState() => GenreModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
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
        buildContent: GenreModal.new,
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
    return InkWell(
      onTap: () {
        ref.read(searchNotifierProvider.notifier).setGenreFilter(
              _isItemSelected(genre) ? null : genre,
            );
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(bottom: 8),
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
              child: Text(genre.name.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall!
                      .copyWith(color: context.colorScheme.onSurface)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                genre.name,
                style: context.textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isItemSelected(GenreEnum genre) =>
      ref.watch(searchNotifierProvider).genreFilter == genre;
}
