import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/artists_dummy.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_controller.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ArtistModal extends ConsumerStatefulWidget {
  const ArtistModal({super.key});

  @override
  ArtistModalState createState() => ArtistModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
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
          title: 'Select an Artist',
        ),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: ArtistModal.new,
      ),
    );
  }
}

class ArtistModalState extends ConsumerState<ArtistModal> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final List<Artist> _allArtists = ArtistsDummy.artists;

  List<Artist> _searchedArtists = [];

  @override
  void initState() {
    _searchedArtists = _allArtists;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          StageSearchBar(
            focusNode: _focusNode,
            controller: _searchController,
            onChanged: _searchArtists,
          ),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchedArtists.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  ref.read(searchControllerProvider.notifier).setArtistFilter(
                        _isItemChecked(index) ? null : _searchedArtists[index],
                      );
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _isItemChecked(index)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemChecked(index) ? Colors.blue : Colors.white,
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
                          _searchedArtists.elementAt(index).hashCode.toString(),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          _searchedArtists.elementAt(index).imageUrl ?? '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _searchedArtists.elementAt(index).fullName,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _searchArtists(String value) {
    if (value.isEmpty) {
      _clearSearch();
    }
    setState(() {
      _searchedArtists = _allArtists.where((element) {
        return element.fullName.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchedArtists = _allArtists;
    _focusNode.unfocus();
  }

  bool _isItemChecked(int index) =>
      ref.watch(searchControllerProvider).artistFilter ==
      _searchedArtists.elementAt(index);
}
