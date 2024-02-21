import 'dart:io';

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
  XFile? _imageFile;

  Future<void> _selectImage() async {
    context.popDialog();
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: widget.canChangeProfilePicture
              ? () => showCustomBottomSheet(context)
              : null,
          child: Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: _imageFile != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(
                          File(_imageFile!.path),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> showCustomBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: context.colorScheme.primary,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => const CloseHeader(
          title: SizedBox(),
        ),
        headerHeight: () => CloseHeader.height,
        footerHeight: () => 59,
        buildContent: () => Container(
          margin: const EdgeInsets.only(right: 32, left: 32),
          child: ElevatedButton(
            onPressed: _selectImage,
            child: const Text('Change Profile Picture'),
          ),
        ),
      ),
    );
  }
}
