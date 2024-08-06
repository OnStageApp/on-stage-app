import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CreateRehearsalModal extends ConsumerStatefulWidget {
  const CreateRehearsalModal({
    super.key,
  });

  @override
  CreateRehearsalModalState createState() => CreateRehearsalModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      useRootNavigator: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Add a Rehearsal'),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return const SingleChildScrollView(
            child: CreateRehearsalModal(),
          );
        },
      ),
    );
  }
}

class CreateRehearsalModalState extends ConsumerState<CreateRehearsalModal> {
  List<int> selectedReminders = [0];
  final TextEditingController rehearsalNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Rehearsal Name',
              hint: 'Sunday Morning',
              icon: null,
              controller: rehearsalNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rehearsal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DateTimeTextFieldWidget(
              dateController: dateController,
              timeController: timeController,
            ),
            const SizedBox(height: 24),
            ContinueButton(
              text: 'Create',
              onPressed: _createRehearsal,
              isEnabled: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _createRehearsal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final dateTime = parseDateTime(dateController.text, timeController.text);
    final rehearsal = Rehearsal(
      id: Random().nextInt(1000).toString(),
      name: rehearsalNameController.text,
      dateTime: dateTime,
    );
    ref.read(eventControllerProvider.notifier).addRehearsal(rehearsal);
    context.popDialog();
  }

  DateTime? parseDateTime(String date, String time) {
    try {
      final dateParts = date.split('/');
      if (dateParts.length != 3) {
        return null;
      }
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      final timeParts = time.split(':');
      if (timeParts.length != 2) {
        return null;
      }
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }
  }
}
