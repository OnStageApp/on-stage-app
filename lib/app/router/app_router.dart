import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_moments_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_overview_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_settings_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/login/presentation/login_screen.dart';
import 'package:on_stage_app/app/features/notifications/presentation/notification_page.dart';
import 'package:on_stage_app/app/features/song/presentation/saved_songs_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/song_detail_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/team/presentation/team_details_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/edit_profile_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/main_screen.dart';

export 'package:go_router/go_router.dart';

GlobalKey<NavigatorState> _homeShellKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _songsShellKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _eventsShellKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _profileShellKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  login,
  welcome,
  home,
  songs,
  events,
  addEvent,
  eventDetails,
  profile,
  song,
  notification,
  favorites,
  vocalModal,
  addEventSongs,
  eventSettings,
  editProfile,
  teamDetails,
}

class AppRouter {
  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            state.error?.toString() ?? 'error message',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    ),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeShellKey,
            routes: [
              GoRoute(
                name: AppRoute.home.name,
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _songsShellKey,
            routes: [
              GoRoute(
                name: AppRoute.songs.name,
                path: '/songs',
                builder: (context, state) => const SongsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.song.name,
                    path: 'song',
                    builder: (context, state) {
                      final eventItems = state.extra as List<EventItem>?;
                      final currentIndex =
                          state.uri.queryParameters['currentIndex'];
                      final songId = state.uri.queryParameters['songId'];
                      return SongDetailScreen(
                        eventItems: eventItems,
                        currentIndex: currentIndex != null
                            ? int.parse(currentIndex)
                            : null,
                        songId: songId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _eventsShellKey,
            routes: [
              GoRoute(
                name: AppRoute.events.name,
                path: '/events',
                builder: (context, state) => const EventsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.addEvent.name,
                    path: 'addEvent',
                    builder: (context, state) => const AddEventDetailsScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.addEventSongs.name,
                    path: 'addEventSongs',
                    builder: (context, state) {
                      final eventId = state.uri.queryParameters['eventId']!;

                      final isCreatingEvent =
                          state.uri.queryParameters['isCreatingEvent'] ==
                              'true';

                      return AddEventMomentsScreen(
                        eventId: eventId,
                        isCreatingEvent: isCreatingEvent,
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoute.eventDetails.name,
                    path: 'eventDetails',
                    builder: (context, state) {
                      final eventId = state.uri.queryParameters['eventId'];
                      return EventOverviewScreen(eventId!);
                    },
                    routes: [
                      GoRoute(
                        name: AppRoute.eventSettings.name,
                        path: 'eventSettings',
                        builder: (context, state) {
                          return const EventSettingsScreen();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileShellKey,
            routes: [
              GoRoute(
                name: AppRoute.profile.name,
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    name: AppRoute.editProfile.name,
                    path: 'editProfile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.teamDetails.name,
                    path: 'teamDetails',
                    builder: (context, state) => const TeamDetailsScreen(),
                  ),
                  GoRoute(
                    name: AppRoute.notification.name,
                    path: 'notification',
                    builder: (context, state) => const NotificationPage(),
                  ),
                  GoRoute(
                    name: AppRoute.favorites.name,
                    path: 'favorites',
                    builder: (context, state) => const SavedSongsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.login.name,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoute.welcome.name,
        path: '/welcome',
        builder: (context, state) => const HomeScreen(),
        redirect: (context, state) {
          return state.nameLocation(AppRoute.home.name);
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}

extension GoRouterExtension on GoRouter {
  String nameLocation(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
  }) {
    final location = namedLocation(
      name,
      pathParameters: params,
      queryParameters: queryParams,
    );
    return location.replaceAll('?', '');
  }
}

extension GoRouterStateExtension on GoRouterState {
  String nameLocation(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
  }) {
    final location = namedLocation(
      name,
      pathParameters: params,
      queryParameters: queryParams,
    );
    return location.replaceAll('?', '');
  }
}
