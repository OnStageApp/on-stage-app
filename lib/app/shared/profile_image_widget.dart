import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/shared/close_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
  Widget build(BuildContext context) {
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
          image: widget.profilePicture != null
              ? DecorationImage(
                  image: MemoryImage(widget.profilePicture!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: widget.profilePicture == null
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
            onPressed: null,
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
