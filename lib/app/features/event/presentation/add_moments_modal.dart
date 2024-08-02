import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event_items/event_items_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddMomentsModal extends ConsumerStatefulWidget {
  const AddMomentsModal({
    super.key,
  });

  @override
  AddMomentsModalState createState() => AddMomentsModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Add moments'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: AddMomentsModal(),
          );
        },
      ),
    );
  }
}

class AddMomentsModalState extends ConsumerState<AddMomentsModal> {
  List<int> selectedReminders = [0];
  late List<String> _moments;

  @override
  void initState() {
    _moments =
        ref.read(eventItemsNotifierProvider.notifier).getStructureItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _moments.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      ref.read(eventControllerProvider.notifier).removeMoment(
                            _moments.elementAt(index),
                          );
                    } else {
                      ref.read(eventControllerProvider.notifier).addMoment(
                            _moments.elementAt(index),
                          );
                    }
                  });
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
                      Text(
                        _moments.elementAt(index) ?? '',
                        style: context.textTheme.titleMedium,
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
                              : context.colorScheme.surfaceDim,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ContinueButton(
            text: 'Add Moment',
            onPressed: () {
              ref
                  .read(eventControllerProvider.notifier)
                  .addSelectedMomentsToEventItems();
              context.popDialog();
            },
            isEnabled: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  bool _isItemChecked(int index) =>
      ref.watch(eventControllerProvider).moments.contains(
            _moments.elementAt(index),
          );
}
