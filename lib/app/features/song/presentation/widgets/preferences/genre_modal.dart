import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/genres_dummy.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
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
      backgroundColor: const Color(0xFFF4F4F4),
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
  final List<String> _allGenres = GenresDummy.genres;
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTile('All'),
          const SizedBox(height: 6),
          const DashedLineDivider(),
          const SizedBox(height: 12),
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

  Widget _buildTile(String genre) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGenre = genre;
        });
        if (genre.toLowerCase() == 'all') {
          ref.read(searchControllerProvider.notifier).setGenreFilter(null);
          return;
        }
        final searchFilter = SearchFilter(
          type: SearchFilterEnum.genre,
          value: genre,
        );
        ref.read(searchControllerProvider.notifier).setGenreFilter(
              searchFilter,
            );
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _isItemSelected(genre)
              ? Colors.blue.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isItemSelected(genre) ? Colors.blue : Colors.white,
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
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                  width: 3,
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                genre.substring(0, 1),
                textAlign: TextAlign.center,
                style: context.textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                genre,
                style: context.textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isItemSelected(String genre) => _selectedGenre == genre;
}
