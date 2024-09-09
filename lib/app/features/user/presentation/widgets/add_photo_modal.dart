import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddPhotoModal extends ConsumerStatefulWidget {
  const AddPhotoModal({
    super.key,
  });

  @override
  AddPhotoModalState createState() => AddPhotoModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet<Widget>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Select Positions'),
        headerHeight: () => 64,
        buildContent: () {
          return const AddPhotoModal();
        },
      ),
    );
  }
}

class AddPhotoModalState extends ConsumerState<AddPhotoModal> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.normal,
        vertical: Insets.large,
      ),
      child: EventActionButton(
        onTap: _selectImage,
        text: 'Add Photo From Library',
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imagePath = File(pickedImage.path ?? '');

      unawaited(ref.read(userNotifierProvider.notifier).uploadPhoto(imagePath));
    } else {
      print('No image selected.');
    }
    if (mounted) context.popDialog();
  }
}
