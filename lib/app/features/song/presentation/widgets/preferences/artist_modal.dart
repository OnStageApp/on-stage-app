import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artists_notifier.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
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

  List<Artist> _artists = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(artistsNotifierProvider.notifier).getArtists();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _artists = ref.watch(artistsNotifierProvider).artists;
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
            itemCount: _artists.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  ref.read(searchNotifierProvider.notifier).setArtistFilter(
                        _isItemChecked(index) ? null : _artists[index],
                      );
                  context.popDialog();
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemChecked(index)
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
                          _artists.elementAt(index).hashCode.toString(),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        // child: _artists.elementAt(index).imageUrl != null
                        //     ? Image.asset(
                        //         _artists.elementAt(index).imageUrl ?? '',
                        //       )
                        //     :
                        child: Icon(
                          Icons.person,
                          color: context.colorScheme.surfaceDim,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _artists.elementAt(index).name,
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
    // if (value.isEmpty) {
    //   _clearSearch();
    // }
    // setState(() {
    //   _artists = _allArtists.where((element) {
    //     return element.name.toLowerCase().contains(
    //           _searchController.text.toLowerCase(),
    //         );
    //   }).toList();
    // });
  }

  void _clearSearch() {
    // _searchController.clear();
    // _artists = _allArtists;
    // _focusNode.unfocus();
  }

  bool _isItemChecked(int index) =>
      ref.watch(searchNotifierProvider).artistFilter ==
      _artists.elementAt(index);
}
