import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChooseStructureToAddModal extends ConsumerStatefulWidget {
  const ChooseStructureToAddModal({
    super.key,
  });

  @override
  ChooseStructureToAddModalState createState() =>
      ChooseStructureToAddModalState();

  static Future<StructureItem?> show({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    return showModalBottomSheet<StructureItem>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => const ChooseStructureToAddModal(),
    );
  }
}

class ChooseStructureToAddModalState
    extends ConsumerState<ChooseStructureToAddModal> {
  StructureItem? _selectedStructureItem;

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      buildFooter: () => _buildFooter(context),
      headerHeight: () {
        return 64;
      },
      footerHeight: () {
        return 64;
      },
      buildContent: () => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: StructureItem.values.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      setState(() {
                        _selectedStructureItem = null;
                      });
                    } else {
                      setState(() {
                        _selectedStructureItem = StructureItem.values[index];
                      });
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
                          StructureItem.values[index].index,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurfaceVariant,
                          border: Border.all(
                            color: Color(
                              StructureItem.values[index].color,
                            ),
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          StructureItem.values[index].shortName,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          StructureItem.values[index].name,
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

  bool _isItemChecked(int index) {
    return _selectedStructureItem == StructureItem.values[index];
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
              Navigator.of(context).pop(_selectedStructureItem);
            },
            isEnabled: true,
          )),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const ModalHeader(
      title: 'Song Structure',
    );
  }
}
