import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/date_time_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class CreateRehearsalModal extends ConsumerStatefulWidget {
  const CreateRehearsalModal({
    this.rehearsal,
    this.onRehearsalCreated,
    super.key,
  });

  final void Function(RehearsalModel)? onRehearsalCreated;
  final RehearsalModel? rehearsal;

  @override
  CreateRehearsalModalState createState() => CreateRehearsalModalState();

  static void show({
    required BuildContext context,
    RehearsalModel? rehearsal,
    void Function(RehearsalModel)? onRehearsalCreated,
  }) {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Add a Rehearsal'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: CreateRehearsalModal(
              onRehearsalCreated: onRehearsalCreated,
              rehearsal: rehearsal,
            ),
          ),
        ),
      ),
    );
  }
}

class CreateRehearsalModalState extends ConsumerState<CreateRehearsalModal> {
  List<int> selectedReminders = [0];
  final TextEditingController _rehearsalNameController =
      TextEditingController();
  final FocusNode _rehearsalNameFocus = FocusNode();
  String? _dateTimeString;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
      FocusScope.of(context).requestFocus(_rehearsalNameFocus);
    });
  }

  void _initControllers() {
    setState(() {
      _rehearsalNameController.text = widget.rehearsal?.name ?? '';
    });
  }

  @override
  void dispose() {
    _rehearsalNameFocus.dispose();
    super.dispose();
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
              focusNode: _rehearsalNameFocus,
              controller: _rehearsalNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rehearsal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DateTimeTextFieldWidget(
              initialDateTime: widget.rehearsal?.dateTime,
              onDateTimeChanged: (dateTime) {
                _dateTimeString = dateTime;
              },
            ),
            const SizedBox(height: 32),
            ContinueButton(
              text: widget.rehearsal != null ? 'Update' : 'Create',
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

    FocusScope.of(context).unfocus();

    final dateTime = widget.rehearsal?.dateTime ??
        TimeUtils().parseDateTime(_dateTimeString ?? '');

    final rehearsal = RehearsalModel(
      id: widget.rehearsal?.id,
      name: _rehearsalNameController.text,
      dateTime: dateTime,
      eventId:
          widget.rehearsal?.id ?? ref.read(eventNotifierProvider).event?.id!,
      location: '',
    );

    widget.onRehearsalCreated?.call(rehearsal);
    ref.read(eventControllerProvider.notifier).addRehearsal(rehearsal);
    context.popDialog();
  }
}
