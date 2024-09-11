import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/custom_switch_list_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _value = false;

  @override
  void initState() {
    //TODO: It's not changing the state if it's not loading or smth
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).getCurrentUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Profile', style: context.textTheme.headlineLarge),
                const SizedBox(height: 32),
                SizedBox(
                  height: 105,
                  child: Row(
                    children: [
                      ProfileImageWidget(
                        profilePicture:
                            ref.watch(userNotifierProvider).currentUser?.image,
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
                            Row(
                              children: [
                                Text(
                                  'Chitara Bass',
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: context.colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Ink(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.onSurfaceVariant,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Free Plan',
                                    style:
                                        context.textTheme.bodyMedium!.copyWith(
                                      color: context.colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      context.colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  context.pushNamed(AppRoute.editProfile.name);
                                },
                                child: Text(
                                  'Edit Profile',
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Song View',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ToggleSwitch(
                        borderColor: [
                          context.colorScheme.onSurfaceVariant,
                        ],
                        borderWidth: 5,
                        activeFgColor: context.colorScheme.onSurfaceVariant,
                        fontSize: 16,
                        inactiveFgColor: context.colorScheme.onSurface,
                        activeBgColor: [context.colorScheme.primary],
                        inactiveBgColor: context.colorScheme.onSurfaceVariant,
                        minWidth: double.infinity,
                        minHeight: 38,
                        cornerRadius: 10,
                        totalSwitches: 3,
                        radiusStyle: true,
                        labels: const ['Chords', 'Numeric', 'Lyrics Only'],
                        onToggle: (index) {
                          if (kDebugMode) {
                            print('switched to: $index');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Teams',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            title: Text(
                              'Team Name',
                              style: context.textTheme.headlineMedium,
                            ),
                            subtitle: Text(
                              '4 Members',
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.colorScheme.outline,
                              ),
                            ),
                            trailing: const ParticipantsOnTile(
                              participantsProfile: [
                                'assets/images/profile1.png',
                                'assets/images/profile2.png',
                                'assets/images/profile4.png',
                                'assets/images/profile5.png',
                                'assets/images/profile5.png',
                                'assets/images/profile5.png',
                                'assets/images/profile5.png',
                                'assets/images/profile5.png',
                              ],
                            ),
                            onTap: () {
                              context.pushNamed(AppRoute.teamDetails.name);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Membership',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: context.colorScheme.outline,
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        title: Text(
                          'Free Plan',
                          style: context.textTheme.titleMedium,
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Upgrade',
                            style: context.textTheme.titleMedium!
                                .copyWith(color: context.colorScheme.outline),
                          ),
                        ),
                        onTap: () {
                          context.goNamed(AppRoute.favorites.name);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'App Settings',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    CustomSwitchListTile(
                      title: 'Dark Mode',
                      icon: Icons.dark_mode,
                      value:
                          ref.watch(themeProvider).theme != onStageLightTheme,
                      onSwitch: (value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomSwitchListTile(
                      title: 'Notifications',
                      icon: Icons.notifications,
                      value: !_value,
                      onSwitch: (value) {
                        setState(() {
                          _value = !value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Library',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        title: Text(
                          'Saved Songs',
                          style: context.textTheme.titleMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${ref.watch(songsNotifierProvider).savedSongs.length}',
                              style: context.textTheme.titleMedium!
                                  .copyWith(color: context.colorScheme.outline),
                            ),
                            const SizedBox(width: 8),
                            _buildArrowWidget(context),
                          ],
                        ),
                        onTap: () {
                          context.goNamed(AppRoute.favorites.name);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        title: Text(
                          'Request a new song',
                          style: context.textTheme.titleMedium!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                        trailing: _buildArrowWidget(context),
                        onTap: () {
                          context.goNamed(AppRoute.songs.name);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        title: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: context.colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Sign Out',
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        onTap: () {
                          context.goNamed(AppRoute.login.name);
                        },
                      ),
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

  Widget _buildArrowWidget(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Assets.icons.arrowForward.svg(),
      ),
    );
  }
}
