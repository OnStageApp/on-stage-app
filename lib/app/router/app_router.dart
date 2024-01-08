import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/login/presentation/login_screen.dart';
import 'package:on_stage_app/app/features/profile/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/main_screen.dart';

export 'package:go_router/go_router.dart';

enum AppRoute {
  login,
  welcome,
  home,
  songs,
  events,
  addEvent,
  profile,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
      GoRoute(
        name: AppRoute.login.name,
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoute.welcome.name,
        path: '/welcome',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        name: AppRoute.home.name,
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoute.songs.name,
        path: '/songs',
        builder: (context, state) => const SongsScreen(),
      ),
      GoRoute(
        name: AppRoute.events.name,
        path: '/events',
        builder: (context, state) => const EventsScreen(),
        routes: [
          GoRoute(
            name: AppRoute.addEvent.name,
            path: 'addEvent',
            builder: (context, state) => const AddEventScreen(),
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.profile.name,
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
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
