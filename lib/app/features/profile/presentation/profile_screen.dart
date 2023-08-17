import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/profile/presentation/widgets/profile_tile.dart';
import 'package:on_stage_app/app/theme/assets.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: context.colorScheme.outline,
        thickness: 1,
        height: 0,
      ),
    );
  }

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
                          style: context.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@johnmayer03',
                          style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile1.png'),
                          radius: 40,
                        )
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
                        icon: Assets.bookmarked,
                        title: 'Saved',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Assets.friends,
                        title: 'Friends',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Assets.song,
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
                        icon: Assets.settings,
                        title: 'App Settings',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Assets.notification,
                        title: 'Notifications',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Assets.account,
                        title: 'Account',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Assets.account,
                        title: 'Account',
                        totalNumber: '5',
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
                        icon: Assets.notes,
                        title: 'Request a song',
                        totalNumber: '5',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 98),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      ProfileTile(
                        icon: Assets.logout,
                        title: 'Logout',
                        totalNumber: '5',
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
}
