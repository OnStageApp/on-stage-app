import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class AddPhotoModal extends ConsumerStatefulWidget {
  const AddPhotoModal({super.key});

  @override
  AddPhotoModalState createState() => AddPhotoModalState();

  static void show({required BuildContext context}) {
    showModalBottomSheet<Widget>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const ModalHeader(title: 'Add Photo'),
        headerHeight: () => 64,
        buildContent: () => const AddPhotoModal(),
      ),
    );
  }
}

class AddPhotoModalState extends ConsumerState<AddPhotoModal> {
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

  Future<File?> compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = path.join(
        dir.absolute.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 25,
    );

    var newFile = File(result!.path);
    return newFile;
  }

  Future<void> _selectImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);
        print('Selected image path: ${imageFile.path}');
        print('Selected image size: ${await imageFile.length()} bytes');
        print('Selected image mime type: ${pickedImage.mimeType}');

        // Compress the image
        final compressedFile = await compressImage(imageFile);

        if (compressedFile != null) {
          print('Compressed image path: ${compressedFile.path}');
          print(
              'Compressed image size: ${await compressedFile.length()} bytes');

          await ref
              .read(userNotifierProvider.notifier)
              .uploadPhoto(compressedFile);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo uploaded successfully')),
          );
        } else {
          throw Exception('Failed to compress image');
        }
      }
    } catch (e) {
      print('Error selecting, compressing, or uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }
}
