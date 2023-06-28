import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/counter/counter.dart';

enum AppRoute {
  welcome,
  home,
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
      /// This is for testing purposes, has to be deleted
      GoRoute(
        name: AppRoute.welcome.name,
        path: '/welcome',
        builder: (context, state) => const CounterPage(),
      ),
      GoRoute(
        name: AppRoute.home.name,
        path: '/home',
        builder: (context, state) => const HomeScreen(),
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
