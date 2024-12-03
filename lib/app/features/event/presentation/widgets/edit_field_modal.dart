import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditFieldModal extends ConsumerStatefulWidget {
  const EditFieldModal({
    required this.fieldName,
    required this.value,
    required this.onSubmitted,
    super.key,
  });

  final String fieldName;
  final String value;
  final void Function(String) onSubmitted;

  @override
  EditFieldModalState createState() => EditFieldModalState();

  static void show({
    required BuildContext context,
    required String fieldName,
    required String value,
    required void Function(String) onSubmitted,
  }) {
    showModalBottomSheet<Widget>(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      context: context,
      builder: (context) => SafeArea(
        child: NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Event Settings'),
          headerHeight: () => 64,
          buildContent: () => EditFieldModal(
            fieldName: fieldName,
            onSubmitted: onSubmitted,
            value: value,
          ),
        ),
      ),
    );
  }
}

class EditFieldModalState extends ConsumerState<EditFieldModal> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              focusNode: _focusNode,
              label: widget.fieldName,
              hint: '',
              icon: null,
              controller: _controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ContinueButton(
              text: 'Save',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmitted(_controller.text);
                  Navigator.of(context).pop();
                }
              },
              isEnabled: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
