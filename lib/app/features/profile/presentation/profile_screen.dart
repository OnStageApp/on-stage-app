import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/profile/presentation/widgets/profile_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


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
                          radius: 32,
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
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.perm_identity_rounded,
                        title: 'Account',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileTile(
                        icon: Icons.heart_broken,
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
                        icon: Icons.logout,
                        title: 'Logout',
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
        color: context.colorScheme.outline,
        thickness: 1,
        height: 0,
      ),
    );
  }
}
