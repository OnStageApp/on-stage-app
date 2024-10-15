import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/add_photo_modal.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/position_tile_widget.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _isUploading = false;
  bool _isNameChanged = false;
  String? _initialName;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userNotifierProvider).currentUser;
      if (user != null) {
        setState(() {
          _initialName = user.name ?? '';
          _nameController.text = _initialName!;
        });
      }
    });
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onNameChanged)
      ..dispose();
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {
      _isNameChanged =
          _nameController.text != _initialName && _initialName != null;
    });
  }

  Future<void> _editProfile() async {
    final user = ref.read(userNotifierProvider).currentUser;

    final updatedName = _nameController.text;

    if (updatedName != _initialName) {
      final updatedUser = user?.copyWith(name: updatedName);

      await ref.read(userNotifierProvider.notifier).editUserById(
            updatedUser!,
          );

      setState(() {
        _initialName = updatedName;
        _isNameChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider).currentUser;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: Padding(
        padding: defaultScreenHorizontalPadding,
        child: ContinueButton(
          text: 'Edit Profile',
          onPressed: _isNameChanged ? _editProfile : () {},
          isEnabled: _isNameChanged,
        ),
      ),
      appBar: StageAppBar(
        title: 'Edit Profile',
        isBackButtonVisible: true,
        background: context.colorScheme.surface,
      ),
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: ProfileImageWidget(
                        size: 140,
                        canChangeProfilePicture: true,
                        userId: user?.id ?? '',
                        name: user?.name ?? 'User',
                        photo: user?.image,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Padding(
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
                              backgroundColor:
                                  context.colorScheme.onSurfaceVariant,
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
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Full Name',
                      hint: '',
                      icon: Icons.church,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an event name';
                        }
                        return null;
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
                    const PositionTile(),
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
                    const SizedBox(
                      height: 100,
                    ), // Add extra padding at the bottom
                  ],
                ),
              ),
            ),
          ],
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
            TopFlushBar.show(
              context,
              'Photo uploaded successfully',
            );
          }
        } else {
          throw Exception('Failed to compress image');
        }
      } catch (e) {
        logger.i('Error compressing or uploading image: $e');
        if (mounted) {
          TopFlushBar.show(
            context,
            'Failed to upload photo',
            isError: true,
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
