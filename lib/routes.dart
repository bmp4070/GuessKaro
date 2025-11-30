import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/play_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/summary_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/setup',
        name: SetupScreen.routeName,
        builder: (context, state) => const SetupScreen(),
      ),
      GoRoute(
        path: '/play',
        name: PlayScreen.routeName,
        builder: (context, state) => const PlayScreen(),
      ),
      GoRoute(
        path: '/summary',
        name: SummaryScreen.routeName,
        builder: (context, state) => const SummaryScreen(),
      ),
    ],
  );
}
