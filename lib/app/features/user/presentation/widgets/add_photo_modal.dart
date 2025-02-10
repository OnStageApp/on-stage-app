import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/add_item_button_widget.dart';
import 'package:on_stage_app/app/shared/utils.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class AddPhotoModal extends ConsumerWidget {
  const AddPhotoModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddItemButtonWidget(
            title: 'Add Photo From Library',
            icon: LucideIcons.image,
            iconColor: context.colorScheme.onSurface,
            backgroundColor: context.colorScheme.surface,
            onPressed: () => _selectAndCropImage(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<File?> _compressImage(File file) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = path.join(
      dir.absolute.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _selectAndCropImage(BuildContext context) async {
    final permissionStatus = await Permission.photos.status;

    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      if (!context.mounted) return;
      await requestPermission(
        permission: Permission.photos,
        context: context,
        onSettingsOpen: () => openSettings(context),
      );
    }

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null && context.mounted) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Edit Photo',
              cropStyle: CropStyle.circle,
              toolbarColor: context.colorScheme.surface,
              toolbarWidgetColor: context.colorScheme.onSurface,
              activeControlsWidgetColor: context.colorScheme.primary,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: false,
              statusBarColor: context.colorScheme.surface,
            ),
            IOSUiSettings(
              title: 'Crop Photo',
              cropStyle: CropStyle.circle,
              cancelButtonTitle: 'Cancel',
              doneButtonTitle: 'Done',
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
              aspectRatioPickerButtonHidden: true,
              rotateButtonsHidden: true,
              rotateClockwiseButtonHidden: true,
            ),
          ],
        );

        if (croppedFile != null && context.mounted) {
          final compressedFile = await _compressImage(File(croppedFile.path));
          if (compressedFile != null && context.mounted) {
            Navigator.of(context).pop(compressedFile);
          }
        }
      }
    } else {
      logger.i('Permission not granted. Cannot open photo picker.');
    }
  }

  static Future<File?> show({required BuildContext context}) async {
    return AdaptiveModal.show<File>(
      context: context,
      isFloatingForLargeScreens: true,
      expand: false,
      child: const AddPhotoModal(),
    );
  }
}
