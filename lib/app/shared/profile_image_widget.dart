import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({super.key, this.canChangeProfilePicture = false});

  final bool canChangeProfilePicture;

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  Uint8List? _imageBytes;

  Future<void> _selectImage() async {
    context.popDialog();
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: widget.canChangeProfilePicture
              ? () => _showCustomBottomSheet(context)
              : null,
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: _imageBytes != null
                ? Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(_imageBytes!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCustomBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
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
