import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_moments_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_settings_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/loading/presentation/loading_screen.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/presentation/login_screen.dart';
import 'package:on_stage_app/app/features/login/presentation/sign_up_screen.dart';
import 'package:on_stage_app/app/features/notifications/presentation/notification_page.dart';
import 'package:on_stage_app/app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/saved_songs_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/song_detail_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/team/domain/team.dart';
import 'package:on_stage_app/app/features/team/presentation/add_team_member_screen.dart';
import 'package:on_stage_app/app/features/team/presentation/team_details_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/change_password_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/edit_profile_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/main_screen.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_notifier.g.dart';

@Riverpod(keepAlive: true)
class NavigationNotifier extends _$NavigationNotifier {
  @override
  GoRouter build() {
    return _createRouter();
  }

  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _homeShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _songsShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _eventsShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _profileShellKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  GlobalKey<NavigatorState> get homeShellKey => _homeShellKey;

  GlobalKey<NavigatorState> get songsShellKey => _songsShellKey;

  GlobalKey<NavigatorState> get eventsShellKey => _eventsShellKey;

  GlobalKey<NavigatorState> get profileShellKey => _profileShellKey;

  void _resetNavigatorKeys() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _homeShellKey = GlobalKey<NavigatorState>();
    _songsShellKey = GlobalKey<NavigatorState>();
    _eventsShellKey = GlobalKey<NavigatorState>();
    _profileShellKey = GlobalKey<NavigatorState>();
  }

  void resetRouter() {
    _resetNavigatorKeys();
    state = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/welcome',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final loginState = ref.watch(loginNotifierProvider);
        final isLoggedIn = loginState.isLoggedIn;
        final isLoading = loginState.isLoading;
        final currentLocation = state.uri.toString();

        if (isLoading) {
          return '/loading';
        }

        if (isLoggedIn) {
          if (currentLocation == '/login' ||
              currentLocation == '/welcome' ||
              currentLocation == '/login/signUp') {
            return '/home';
          }
        } else {
          if (currentLocation != '/login' &&
              currentLocation != '/loading' &&
              currentLocation != '/login/signUp') {
            return '/login';
          }
        }

        return null; // No redirection needed
      },
      routes: _routes(),
      errorPageBuilder: _errorPageBuilder,
    );
  }

  List<RouteBase> _routes() => [
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
                GoRoute(
                  name: AppRoute.onboarding.name,
                  path: '/onboarding',
                  builder: (context, state) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showOnboardingOverlay(context);
                    });
                    return const SizedBox.shrink();
                  },
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
                      builder: (context, state) =>
                          const AddEventDetailsScreen(),
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
                        return EventDetailsScreen(eventId!);
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
                      name: AppRoute.changePassword.name,
                      path: 'changePassword',
                      builder: (context, state) => const ChangePasswordScreen(),
                    ),
                    GoRoute(
                      name: AppRoute.teamDetails.name,
                      path: 'teamDetails',
                      builder: (context, state) {
                        final team = state.extra as Team?;
                        final isCreating = bool.tryParse(
                              state.uri.queryParameters['isCreating']
                                  .toString(),
                            ) ??
                            false;

                        return TeamDetailsScreen(
                          isCreating: isCreating,
                          team: team,
                        );
                      },
                      routes: [
                        GoRoute(
                          name: AppRoute.addTeamMember.name,
                          path: 'addTeamMember',
                          builder: (context, state) {
                            return const AddTeamMemberScreen();
                          },
                        ),
                      ],
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
          name: AppRoute.loading.name,
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),
        GoRoute(
          name: AppRoute.login.name,
          path: '/login',
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              name: AppRoute.signUp.name,
              path: 'signUp',
              builder: (context, state) => const SignUpScreen(),
            ),
          ],
        ),
        GoRoute(
          name: AppRoute.welcome.name,
          path: '/welcome',
          builder: (context, state) => const HomeScreen(),
          redirect: (context, state) {
            return '/home';
          },
        ),
      ];

  Page<void> _errorPageBuilder(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            state.error?.toString() ?? 'error message',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
