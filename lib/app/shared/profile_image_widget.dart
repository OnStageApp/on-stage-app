import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfileImageWidget extends ConsumerStatefulWidget {
  const ProfileImageWidget({
    super.key,
    this.canChangeProfilePicture = false,
    this.profilePicture,
    this.size = 100,
  });

  final bool canChangeProfilePicture;
  final Uint8List? profilePicture;
  final double size;

  @override
  ConsumerState<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends ConsumerState<ProfileImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectImage() async {
    context.popDialog();
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final appDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      final targetPath = p.join(
          appDirectory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');

      final imageFile = File(pickedImage.path);
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        minHeight: 200,
        minWidth: 200,
        targetPath,
        quality: 1,
      );

      if (compressedImage != null) {
        final image = File(compressedImage.path);
        unawaited(ref.read(userNotifierProvider.notifier).uploadPhoto(image));
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    return GestureDetector(
      onTap: widget.canChangeProfilePicture
          ? () => _showCustomBottomSheet(context)
          : null,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.primaryContainer,
          ),
          shape: BoxShape.circle,
          image: userState.currentUser?.image != null
              ? DecorationImage(
                  image: MemoryImage(userState.currentUser!.image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: userState.currentUser?.image == null
            ? Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: context.colorScheme.primaryContainer,
                  size: widget.size * 0.6,
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _showCustomBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const CloseHeader(
          title: SizedBox(),
        ),
        headerHeight: () => CloseHeader.height,
        footerHeight: () => 64,
        buildContent: () => Container(
          margin: const EdgeInsets.only(right: 64, left: 64),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return context.colorScheme.onPrimary;
                },
              ),
            ),
            onPressed: _selectImage,
            child: Text(
              'Change Profile Picture',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.surface,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
