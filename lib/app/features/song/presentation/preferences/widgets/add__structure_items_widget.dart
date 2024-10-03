import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddStructureItemsWidget extends ConsumerStatefulWidget {
  const AddStructureItemsWidget({super.key});

  @override
  AddStructureItemsWidgetState createState() => AddStructureItemsWidgetState();
}

class AddStructureItemsWidgetState
    extends ConsumerState<AddStructureItemsWidget> {
  List<Section> _originalSections = [];
  final List<Section> _addedSections = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _originalSections =
            ref.watch(songNotifierProvider).originalSongSections;
      });
    });
  }

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
            itemCount: _originalSections.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      _addedSections.remove(_originalSections.elementAt(index));
                      ref
                          .read(songPreferencesControllerProvider.notifier)
                          .removeSongSection(
                              _originalSections.elementAt(index));
                    } else {
                      _addedSections.add(_originalSections.elementAt(index));
                      ref
                          .read(songPreferencesControllerProvider.notifier)
                          .addSongSection(_originalSections.elementAt(index));
                    }
                  });
                },
                child: Container(
                  height: 52,
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
                          _originalSections.elementAt(index).structure.id,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurfaceVariant,
                          border: Border.all(
                            color: Color(
                              _originalSections
                                  .elementAt(index)
                                  .structure
                                  .item
                                  .color,
                            ),
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _originalSections
                              .elementAt(index)
                              .structure
                              .item
                              .shortName,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _originalSections
                              .elementAt(index)
                              .structure
                              .item
                              .name,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          _isItemChecked(index)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: _isItemChecked(index)
                              ? context.colorScheme.primary
                              : context.colorScheme.surfaceBright,
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

  bool _isItemChecked(int index) => _addedSections.contains(
        _originalSections.elementAt(index),
      );
}
