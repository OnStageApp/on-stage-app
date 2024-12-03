import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/add_item_button_widget.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddPhotoModal extends StatelessWidget {
  const AddPhotoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        children: [
          AddItemButtonWidget(
            title: 'Add Photo From Library',
            icon: Icons.library_add,
            iconColor: context.colorScheme.primary,
            backgroundColor: context.colorScheme.surface,
            onPressed: () => _selectImage(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Navigator.of(context).pop(File(pickedImage.path));
    }
  }

  static Future<File?> show({required BuildContext context}) async {
    return showModalBottomSheet<File>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildContent: () {
          return const AddPhotoModal();
        },
      ),
    );
  }
}
