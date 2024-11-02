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
import 'package:on_stage_app/app/utils/permission/permission_notifier.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.colorScheme.onSurfaceVariant,
        selectedLabelStyle: context.textTheme.bodyMedium,
        unselectedLabelStyle: context.textTheme.bodyMedium,
        selectedItemColor: context.colorScheme.primary,
        unselectedItemColor: context.colorScheme.outline,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedFontSize: 1,
        unselectedFontSize: 1,
        elevation: 1,
        onTap: _onChangedScreen,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/nav_home_icon.svg',
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/nav_home_icon.svg',
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
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/nav_list_music_icon.svg',
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
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/nav_calendar_icon.svg',
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
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/nav_profile_icon.svg',
              colorFilter: ColorFilter.mode(
                context.colorScheme.outline,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: widget.navigationShell,
    );
  }

  void _listenForPermissionDeniedAndShowPaywall() {
    ref.listen<PermissionType?>(
      permissionNotifierProvider,
      (previous, permissionType) {
        if (permissionType != null) {
          PaywallModal.show(
            context: context,
            ref: ref,
            permissionType: permissionType,
          );

          ref.read(permissionNotifierProvider.notifier).clearPermission();
        }
      },
    );
  }
}
