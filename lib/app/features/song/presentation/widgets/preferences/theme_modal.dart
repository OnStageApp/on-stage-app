import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/themes_dummy.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ThemeModal extends ConsumerStatefulWidget {
  const ThemeModal({super.key});

  @override
  ThemeModalState createState() => ThemeModalState();

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
        buildHeader: () => const ModalHeader(title: 'Select a Theme'),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: ThemeModal.new,
      ),
    );
  }
}

class ThemeModalState extends ConsumerState<ThemeModal> {
  final List<String> _allThemes = ThemesDummy.themes;
  String? _selectedTheme;

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
            itemCount: _allThemes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedTheme = _allThemes[index];
                  });
                },
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _isItemSelected(index) ? Colors.blue.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemSelected(index) ? Colors.blue : Colors.white,
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
                          _allThemes[index].hashCode.toString(),
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
                          _allThemes[index].substring(0, 1),
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          _allThemes[index],
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

  bool _isItemSelected(int index) => _selectedTheme == _allThemes[index];
}
