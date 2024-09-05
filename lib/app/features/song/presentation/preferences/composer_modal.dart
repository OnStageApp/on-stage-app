import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ComposerModal extends ConsumerStatefulWidget {
  const ComposerModal({
    super.key,
  });

  @override
  ArtistModalState createState() => ArtistModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F4F4),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => const ComposerModal(),
    );
  }
}

class ArtistModalState extends ConsumerState<ComposerModal> {
  // List<Section> _sections = [];
  final List<Artist> _addedArtists = [];
  // bool isAddPage = false;

  final List<Artist> _artists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //_sections = ref.watch(songNotifierProvider).sections;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => const ModalHeader(title: 'Search Composer'),
      buildFooter: () => _buildFooter(context),
      headerHeight: () {
        return 64;
      },
      footerHeight: () {
        return 64;
      },
      buildContent: _buildAddStructures,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32,
        ),
        child: ContinueButton(
          text: 'Add',
          onPressed: () {
            context.popDialog();
          },
          isEnabled: true,
        ),
      ),
    );
  }

  Widget _buildAddStructures() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _artists.length,
            itemBuilder: (context, index) {
              return Container(
                height: 48,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      // key: ValueKey(_sections[index].structure.id),
                      //  decoration: BoxDecoration(
                      //    color: Colors.white,
                      //    border: Border.all(
                      //      color: Color(_artists[index].structure.item.color),
                      //      width: 3,
                      //    ),
                      //    shape: BoxShape.circle,
                      //  ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(_artists[index].imageUrl!),
                        radius: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        _artists[index].name,
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_isItemChecked(index)) {
                            _addedArtists.remove(_artists[index]);
                          } else {
                            _addedArtists.add(_artists[index]);
                          }
                        });

                        // ref
                        //     .read(songNotifierProvider.notifier);
                        //.updateSongSections(_artists);
                      },
                      icon: Icon(
                        _isItemChecked(index)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 24,
                        color: _isItemChecked(index)
                            ? Colors.blue
                            : const Color(0xFFE3E3E3),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isItemChecked(int index) => _addedArtists.contains(_artists[index]);
}
