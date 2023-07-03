import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/profile/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/songs/presentation/songs_screen.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const SongsScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  void _onChangedScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF9F9FC),
        selectedLabelStyle: context.textTheme.labelMedium,
        unselectedLabelStyle: context.textTheme.labelMedium,
        selectedItemColor: context.colorScheme.primary,
        unselectedItemColor: context.colorScheme.outline,
        showUnselectedLabels: true,
        elevation: 0,
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
            backgroundColor: Color(0xFFF9F9FC),
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
      body: screens[_currentIndex],
    );
  }
}
