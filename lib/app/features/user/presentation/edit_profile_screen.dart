import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/add_photo_modal.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/choose_position_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isUploading = false;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userNotifierProvider).currentUser;
    if (user != null) {
      _nameController.text = user.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editProfile() async {
    final user = ref.read(userNotifierProvider).currentUser;

    if (user != null) {
      final updatedName = _nameController.text.trim();

      if (updatedName.isNotEmpty) {
        final updatedUser = user.copyWith(name: updatedName);

        await ref.read(userNotifierProvider.notifier).editUserById(
          user.id,
          updatedUser,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name cannot be empty')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider).currentUser;
    return Scaffold(
      appBar: StageAppBar(
        title: 'Edit Profile',
        isBackButtonVisible: true,
        background: context.colorScheme.surface,
      ),
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ProfileImageWidget(
                  size: 140,
                  canChangeProfilePicture: true,
                  userId: ref.watch(userNotifierProvider).currentUser?.id ?? '',
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Ink(
                    width: 210,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        overlayColor:
                            context.colorScheme.outline.withOpacity(0.1),
                        backgroundColor: context.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _isUploading ? null : _handleAddPhoto,
                      child: _isUploading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Edit Photo',
                              style: context.textTheme.titleMedium,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Full Name',
                  hint: '${user?.name}',
                  icon: Icons.church,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _nameController.text = value;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Positions',
                    style: context.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tileColor: context.colorScheme.onSurfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  dense: true,
                  title: Text(
                    'Chit. Bass',
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.colorScheme.outline),
                  ),
                  trailing: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Assets.icons.arrowForward.svg(),
                    ),
                  ),
                  onTap: () {
                    ChoosePositionModal.show(
                      context: context,
                      ref: ref,
                      onSaved: (i) {},
                      cacheReminders: [123],
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  enabled: false,
                  label: 'Email',
                  hint: '${user?.email}',
                  icon: Icons.church,
                  controller: TextEditingController(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: context.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 12),
                EventActionButton(
                  text: 'Change Password',
                  onTap: () {
                    context.pushNamed(AppRoute.changePassword.name);
                  },
                ),
                const SizedBox(height: 24),
                ContinueButton(text: 'Edit Profile', onPressed: _editProfile, isEnabled: true),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddPhoto() async {
    final selectedImage = await AddPhotoModal.show(context: context);

    if (selectedImage != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final compressedFile = await _compressImage(selectedImage);

        if (compressedFile != null) {
          await ref
              .read(userNotifierProvider.notifier)
              .uploadPhoto(compressedFile);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photo uploaded successfully')),
            );
          }
        } else {
          throw Exception('Failed to compress image');
        }
      } catch (e) {
        logger.i('Error compressing or uploading image: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
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

    final newFile = File(result!.path);
    return newFile;
  }
}
