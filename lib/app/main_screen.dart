import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentTeamMemberNotifierProvider.notifier);
      ref.read(userNotifierProvider.notifier).init();
      ref
          .read(teamMembersNotifierProvider.notifier)
          .fetchAndSaveTeamMemberPhotos();
      ref.read(userSettingsNotifierProvider.notifier).init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.colorScheme.onPrimaryFixed,
        selectedLabelStyle: context.textTheme.bodyMedium,
        unselectedLabelStyle: context.textTheme.bodyMedium,
        selectedItemColor: context.colorScheme.primary,
        unselectedItemColor: context.colorScheme.outline,
        showUnselectedLabels: true,
        elevation: 1,
        onTap: _onChangedScreen,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(
                Icons.home,
              ),
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.music_note),
            ),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.calendar_today),
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.account_circle),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: widget.navigationShell,
    );
  }
}
