import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/pick_image.dart';

import 'close_header.dart';
import 'nested_scroll_modal.dart';
import 'notifications_bottom_sheet.dart';

class ProfileImageWidget extends StatefulWidget {
  final bool canChangeProfilePicture;

  const ProfileImageWidget({Key? key, required this.canChangeProfilePicture})
      : super(key: key);

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  Uint8List? _image;

  Future<void> selectImage() async {
    Navigator.pop(context);
    final img = await pickImage(ImageSource.gallery) as Uint8List;
    setState(() {
      _image = img;
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
            child: CircleAvatar(
              backgroundImage: _image != null ? MemoryImage(_image!) : null,
              backgroundColor: _image != null ? null : Colors.grey,
              radius: 32,
              child: _image == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 48,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showCustomBottomSheet(BuildContext context) async {
    if (widget.canChangeProfilePicture) {
      await showModalBottomSheet(
        backgroundColor: context.colorScheme.background,
        context: context,
        builder: (context) => NestedScrollModal(
          buildHeader: () => const CloseHeader(
            title: Text(''),
          ),
          headerHeight: () => CloseHeader.height,
          footerHeight: () => 59,
          buildContent: () => Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: ElevatedButton(
              onPressed: selectImage,
              child: const Text('Change Profile Picture'),
            ),
          ),
        ),
      );
    }
  }
}
