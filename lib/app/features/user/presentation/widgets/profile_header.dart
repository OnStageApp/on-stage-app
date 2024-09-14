import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/user/domain/models/user/user_model.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/edit_profile_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/user_info.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, super.key});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Row(
        children: [
          ProfileImageWidget(
            profilePicture: user?.image,
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Eugen Ionescu',
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
