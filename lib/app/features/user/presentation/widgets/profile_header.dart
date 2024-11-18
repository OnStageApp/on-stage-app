import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/edit_profile_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/user_info.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).currentUser;
    return SizedBox(
      height: 105,
      child: Row(
        children: [
          ProfileImageWidget(
            userId: user?.id ?? '',
            name: user?.name ?? 'User',
            photo: user?.image,
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user?.name ?? 'user',
                  style: context.textTheme.headlineMedium,
                ),
                const Spacer(),
                const UserInfo(),
                const Spacer(),
                const EditProfileButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
