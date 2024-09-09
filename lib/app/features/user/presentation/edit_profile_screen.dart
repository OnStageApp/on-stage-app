import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/add_photo_modal.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/choose_position_modal.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                const ProfileImageWidget(
                  size: 140,
                  canChangeProfilePicture: true,
                ),
                const SizedBox(height: 18),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 210,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: context.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      AddPhotoModal.show(
                        context: context,
                      );
                    },
                    child: Text(
                      'Edit Photo',
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Eugen Ionescu',
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
                  label: 'Email',
                  hint: 'eionescu@gmail.com',
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
                  onTap: () {},
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
