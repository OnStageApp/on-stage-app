import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class VocalLeadModal extends ConsumerStatefulWidget {
  const VocalLeadModal({super.key});

  @override
  VocalLeadModalState createState() => VocalLeadModalState();

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
        buildFooter: () => SizedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              32,
            ),
            child: ContinueButton(
              hasShadow: true,
              text: 'Add',
              onPressed: () {},
              isEnabled: true,
            ),
          ),
        ),
        buildHeader: () => const ModalHeader(title: 'Add Vocal Lead'),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: VocalLeadModal.new,
      ),
    );
  }
}

class VocalLeadModalState extends ConsumerState<VocalLeadModal> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _allVocals = [
    'Marcelo',
    'Ricardo',
    'Jorge',
    'Lucas1',
    'Lucas2',
    'Lucas3',
    'Lucas4',
    'Lucas5',
    'Lucas6',
    'Lucas7',
    'Lucas8',
    'Lucas9',
    'Lucas10',
    'Lucas',
    'Lucas',
  ];
  List<String> _searchedVocals = [];
  final List<String> _addedVocals = [];

  @override
  void initState() {
    _searchedVocals = _allVocals;
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
            onClosed: () {
              setState(() {
                _searchedVocals = _allVocals.where((element) {
                  return element.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      );
                }).toList();
              });

              _clearSearch();
            },
            onChanged: (value) {
              if (value.isEmpty) {
                _clearSearch();
              }
              setState(() {
                _searchedVocals = _allVocals.where((element) {
                  return element.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      );
                }).toList();
              });
            },
          ),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _searchedVocals.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      _addedVocals.remove(_searchedVocals.elementAt(index));
                    } else {
                      _addedVocals.add(_searchedVocals.elementAt(index));
                    }
                  });
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          _searchedVocals.elementAt(index).hashCode.toString(),
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
                          _searchedVocals.elementAt(index).substring(0, 1),
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _searchedVocals.elementAt(index),
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
                              ? Colors.blue
                              : const Color(0xFFE3E3E3),
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

  void _clearSearch() {
    _searchController.clear();
    _searchedVocals = _allVocals;
    _focusNode.unfocus();
  }

  bool _isItemChecked(int index) => _addedVocals.contains(
        _searchedVocals.elementAt(index),
      );
}
