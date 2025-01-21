import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class CreatePositionModal extends ConsumerStatefulWidget {
  const CreatePositionModal({
    required this.groupId,
    super.key,
  });

  final String groupId;

  static void show({
    required BuildContext context,
    required String groupId,
  }) {
    AdaptiveModal.show(
      context: context,
      child: CreatePositionModal(groupId: groupId),
    );
  }

  @override
  CreatePositionModalState createState() => CreatePositionModalState();
}

class CreatePositionModalState extends ConsumerState<CreatePositionModal> {
  final TextEditingController _positionNameController = TextEditingController();
  final FocusNode _positionNameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_positionNameFocus);
    });
  }

  @override
  void dispose() {
    _positionNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'New Position'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            // Add this wrapper
            child: Padding(
              padding: EdgeInsets.only(
                left: defaultScreenPadding.left,
                right: defaultScreenPadding.right,
                top: defaultScreenPadding.top,
                // Add bottom padding to ensure content isn't hidden behind the button
                bottom: MediaQuery.of(context).viewInsets.bottom + 80,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this
                  children: [
                    CustomTextField(
                      enabled: true,
                      label: 'Position Name',
                      hint: 'eg. Acoustic Guitar',
                      icon: null,
                      focusNode: _positionNameFocus,
                      controller: _positionNameController,
                      validator: (value) {
                        if (value.isNullEmptyOrWhitespace) {
                          return 'Please enter a position name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 12,
          right: 12,
          child: ContinueButton(
            isEnabled: true,
            hasShadow: false,
            text: 'Create',
            onPressed: _addPosition,
          ),
        ),
      ],
    );
  }

  Future<void> _addPosition() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref.read(positionNotifierProvider.notifier).addPosition(
          _positionNameController.text,
          widget.groupId,
        );

    if (context.mounted) context.popDialog();
  }
}
