import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/device/application/device_service.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/network_permission_notifier.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/socket_io_service/socket_io_service.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<Widget> screens = [
    const HomeScreen(),
    const SongsScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  void _onChangedScreen(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initProviders();
    });
    super.initState();
  }

  Future<void> _initProviders() async {
    logger.i('Init providers');
    await ref.read(databaseProvider).initDatabase();
    ref.read(socketIoServiceProvider.notifier);
    unawaited(
      ref.read(notificationNotifierProvider.notifier).getNotifications(),
    );

    ref.read(firebaseNotifierProvider.notifier);

    await Future.wait([
      //TODO: Find a new way to verify deviceId and save it
      ref.read(deviceServiceProvider).verifyDeviceId(),
      ref
          .read(teamMembersNotifierProvider.notifier)
          .fetchAndSaveTeamMemberPhotos(),
      ref.read(userNotifierProvider.notifier).init(),
      ref.read(teamNotifierProvider.notifier).getCurrentTeam(),
      ref.read(currentTeamMemberNotifierProvider.notifier).initializeState(),
      ref.read(userSettingsNotifierProvider.notifier).init(),
      ref.read(subscriptionNotifierProvider.notifier).init(),
      ref
          .read(planServiceProvider.notifier)
          .fetchAndSavePlans(forceRefresh: true),
    ]).then((_) {
      logger.i('All providers initialized');
    }).catchError((error, s) {
      logger.e('Error during provider initialization: $error $s');
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenForPermissionDeniedAndShowPaywall();

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      bottomNavigationBar: context.isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: context.colorScheme.surface,
              selectedLabelStyle: context.textTheme.bodyMedium,
              unselectedLabelStyle: context.textTheme.bodyMedium,
              selectedItemColor: context.colorScheme.onSurface,
              unselectedItemColor: context.colorScheme.outline,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              elevation: 1,
              onTap: _onChangedScreen,
              items: [
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/nav_home_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/nav_home_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.outline,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/nav_list_music_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/nav_list_music_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.outline,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Songs',
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/nav_calendar_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/nav_calendar_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.outline,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icons/nav_profile_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/nav_profile_icon.svg',
                    height: 21,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.outline,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
      body: context.isLargeScreen
          ? Row(
              children: [
                _buildNavigationRail(context),
                Expanded(
                  child: widget.navigationShell,
                ),
              ],
            )
          : widget.navigationShell,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SvgPicture.asset(
            'assets/icons/onstage_icon_blue.svg',
            height: 40,
          ),
        ),
        Expanded(
          child: NavigationRail(
            groupAlignment: 0,
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _onChangedScreen,
            backgroundColor: context.colorScheme.surface,
            selectedLabelTextStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
            unselectedLabelTextStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
            selectedIconTheme: IconThemeData(
              color: context.colorScheme.onSurface,
            ),
            unselectedIconTheme: IconThemeData(
              color: context.colorScheme.outline,
            ),
            labelType: NavigationRailLabelType.all,
            useIndicator: false,
            indicatorColor: context.colorScheme.primary,
            destinations: _navigationItems.map((item) {
              final isSelected = _navigationItems.indexOf(item) ==
                  widget.navigationShell.currentIndex;
              return NavigationRailDestination(
                padding: const EdgeInsets.symmetric(vertical: 12),
                icon: SvgPicture.asset(
                  item.iconPath,
                  height: 21,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? context.colorScheme.onSurface
                        : context.colorScheme.outline,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(item.label),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: context.colorScheme.error,
                ),
                onPressed: () {},
              ),
              const Text('Log Out'),
            ],
          ),
        ),
      ],
    );
  }

  void _listenForPermissionDeniedAndShowPaywall() {
    ref.listen<PermissionType?>(
      networkPermissionProvider,
      (previous, permissionType) {
        if (permissionType != null) {
          PaywallModal.show(
            context: context,
            permissionType: permissionType,
          );

          ref.read(networkPermissionProvider.notifier).clearPermission();
        }
      },
    );
  }
}

final List<_NavigationItem> _navigationItems = [
  _NavigationItem(
    label: 'Home',
    iconPath: 'assets/icons/nav_home_icon.svg',
  ),
  _NavigationItem(
    label: 'Songs',
    iconPath: 'assets/icons/nav_list_music_icon.svg',
  ),
  _NavigationItem(
    label: 'Events',
    iconPath: 'assets/icons/nav_calendar_icon.svg',
  ),
  _NavigationItem(
    label: 'Profile',
    iconPath: 'assets/icons/nav_profile_icon.svg',
  ),
];

class _NavigationItem {
  _NavigationItem({
    required this.label,
    required this.iconPath,
  });

  final String label;
  final String iconPath;
}
