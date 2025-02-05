import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/login/domain/user_request.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/add_photo_modal.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class EditUserProfile extends ConsumerStatefulWidget {
  const EditUserProfile({super.key});

  @override
  EditUserProfileState createState() => EditUserProfileState();
}

class EditUserProfileState extends ConsumerState<EditUserProfile> {
  bool _isUploading = false;
  bool _hasChanges = false;
  String? _initialName;
  String? _initialUsername;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userNotifierProvider).currentUser;
      if (user != null) {
        setState(() {
          _initialName = user.name ?? '';
          _initialUsername = user.username ?? '';
          _nameController.text = _initialName!;
          _usernameController.text = _initialUsername ?? '';
        });
      }
    });
    _nameController.addListener(_checkForChanges);
    _usernameController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_checkForChanges)
      ..dispose();
    _usernameController
      ..removeListener(_checkForChanges)
      ..dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final nameChanged = _nameController.text != _initialName;
    final usernameChanged = _usernameController.text != _initialUsername;

    if (_hasChanges != (nameChanged || usernameChanged)) {
      setState(() {
        _hasChanges = nameChanged || usernameChanged;
      });
    }
  }

  Future<void> _editProfile() async {
    final updatedUserRequest = UserRequest(
      name: _nameController.text,
      username: _usernameController.text,
    );

    FocusScope.of(context).unfocus();
    await ref.read(userNotifierProvider.notifier).editUserById(
          updatedUserRequest,
        );

    setState(() {
      _initialName = updatedUserRequest.name;
      _initialUsername = updatedUserRequest.username;
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: _hasChanges
          ? Padding(
              padding: defaultScreenHorizontalPadding,
              child: ContinueButton(
                text: 'Save',
                onPressed: _hasChanges ? _editProfile : () {},
                isEnabled: _hasChanges,
                hasShadow: false,
              ),
            )
          : const SizedBox(),
      appBar: const StageAppBar(
        title: 'Edit Profile',
        isBackButtonVisible: true,
      ),
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
                        name: userState.currentUser?.name ?? 'User',
                        photo: userState.currentUser?.image,
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
                    //TODO: Maybe add this in the future
                    // const SizedBox(height: 12),

                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Positions',
                    //     style: context.textTheme.titleSmall,
                    //   ),
                    // ),
                    // const SizedBox(height: 12),
                    // const PositionTile(),
                    const SizedBox(height: 12),
                    CustomTextField(
                      enabled: true,
                      label: 'Username',
                      hint: 'Enter your username',
                      icon: Icons.church,
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      enabled: false,
                      label: 'Email',
                      hint: '${userState.currentUser?.email}',
                      icon: Icons.church,
                      controller: TextEditingController(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an event name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    ),
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
        await ref
            .read(userNotifierProvider.notifier)
            .uploadPhoto(selectedImage);

        if (mounted) {
          TopFlushBar.show(
            context,
            'Photo uploaded successfully',
          );
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
}
