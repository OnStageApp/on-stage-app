import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/profile/presentation/widgets/profile_tile.dart';
import 'package:on_stage_app/app/shared/notifications_bottom_sheet.dart';
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
      backgroundColor: context.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'John Mayer',
                          style: context.textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@johnmayer03',
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: <Widget>[
                        Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset(
                            'assets/images/profile1.png',
                            height: 64,
                            width: 64,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.bookmark,
                        title: 'Saved',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.supervised_user_circle,
                        title: 'Friends',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.audiotrack_rounded,
                        title: 'Played',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.settings,
                        title: 'App Settings',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        totalNumber: ref
                            .watch(notificationNotifierProvider)
                            .length
                            .toString(),
                        onTap: () {
                          NotificationsBottomSheet.show(context);
                        },
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.perm_identity_rounded,
                        title: 'Account',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.assignment,
                        title: 'Request a song',
                        iconColor: context.colorScheme.primary,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        iconColor: context.colorScheme.error,
                        onTap: () {},
                      ),
                    ],
                  ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: context.colorScheme.surfaceVariant,
        thickness: 1,
        height: 0,
      ),
    );
  }
}
