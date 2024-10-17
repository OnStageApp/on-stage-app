import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artists_notifier.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/add_artist_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ArtistModal extends ConsumerStatefulWidget {
  const ArtistModal(this.onArtistSelected, {super.key});

  final void Function(Artist) onArtistSelected;

  @override
  ArtistModalState createState() => ArtistModalState();

  static void show({
    required BuildContext context,
    required void Function(Artist) onArtistSelected,
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
        buildContent: () => ArtistModal(onArtistSelected),
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
            // onChanged: _searchArtists,
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(
              _artists.length + 1,
              (index) {
                if (_artists.length == index) {
                  return EventActionButton(
                    text: 'Add Artist',
                    icon: Icons.add,
                    onTap: () async {
                      await AddArtistModal.show(
                        context: context,
                      );
                      await ref
                          .read(artistsNotifierProvider.notifier)
                          .getArtists();
                    },
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      _artists.elementAt(index).name,
                      style: context.textTheme.titleSmall,
                    ),
                    tileColor: _isItemChecked(index)
                        ? context.colorScheme.primary.withOpacity(0.1)
                        : context.colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onTap: () {
                      widget.onArtistSelected(_artists.elementAt(index));
                      context.popDialog();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isItemChecked(int index) =>
      ref.watch(searchNotifierProvider).artistFilter ==
      _artists.elementAt(index);
}


