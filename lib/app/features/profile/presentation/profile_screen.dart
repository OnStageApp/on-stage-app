import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/profile/presentation/widgets/profile_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.outlineVariant.withOpacity(0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Antonio V.',
                          style: context.textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@antonio_vinter',
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const ProfileImageWidget(canChangeProfilePicture: true),
                  ],
                ),
                const SizedBox(height: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTile(
                      icon: Icons.bookmark,
                      title: 'Saved Songs',
                      totalNumber: '5',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    ProfileTile(
                      icon: Icons.people,
                      title: 'Friends',
                      totalNumber: '5',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    ProfileTile(
                      icon: Icons.event,
                      title: 'Events',
                      totalNumber: '5',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    ProfileTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      totalNumber: 4.toString(),
                      onTap: () {},
                    ),
                    _buildDivider(),
                    ProfileTile(
                      icon: Icons.perm_identity_rounded,
                      title: 'Account',
                      onTap: () {
                        context.goNamed(AppRoute.login.name);
                      },
                    ),
                    _buildDivider(),
                    ProfileTile(
                      icon: Icons.assignment,
                      title: 'Complete Profile',
                      iconColor: context.colorScheme.primary,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Column(
                  children: [
                    ProfileTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      iconColor: context.colorScheme.error,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: context.colorScheme.surfaceVariant,
      thickness: 1,
      height: 0,
    );
  }
}
