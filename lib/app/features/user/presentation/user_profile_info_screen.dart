import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/models/profile/user_profile.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class UserProfileInfoScreen extends ConsumerStatefulWidget {
  const UserProfileInfoScreen({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  UserProfileInfoScreenState createState() => UserProfileInfoScreenState();
}

class UserProfileInfoScreenState extends ConsumerState<UserProfileInfoScreen> {
  UserProfileInfo? user;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initUser();
    });
  }

  Future<void> _initUser() async {
    final userInfo = await ref
        .read(userNotifierProvider.notifier)
        .getUserProfileInfo(widget.userId);

    if (mounted) {
      setState(() {
        user = userInfo;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      appBar: const StageAppBar(
        title: 'User Profile',
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
                        name: user?.name ?? '',
                        photo: user?.image,
                      ),
                    ),
                    const SizedBox(height: 36),
                    CustomTextField(
                      enabled: false,
                      label: 'Full Name',
                      hint: user?.name ?? '',
                      icon: Icons.church,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      enabled: false,
                      label: 'Username',
                      hint: user?.username ?? '',
                      icon: Icons.church,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      enabled: false,
                      label: 'Email',
                      hint: user?.email ?? '',
                      icon: Icons.church,
                      controller: _nameController,
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
}
