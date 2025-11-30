import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/play_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/summary_screen.dart';
import 'state/game_state.dart';

GoRouter createRouter(GameState gameState) {
  return GoRouter(
    refreshListenable: gameState,
    redirect: (context, state) {
      final path = state.uri.path;
      final hasSelection = gameState.hasSelection;

      if (!hasSelection && path != '/') {
        return '/';
      }

      final hasRoundReady = gameState.isRoundActive || gameState.lastResult != null;

      if (path == '/play' && !hasRoundReady) {
        return hasSelection ? '/setup' : '/';
      }

      if (path == '/summary' && gameState.lastResult == null) {
        return hasSelection ? '/setup' : '/';
      }

      return null;
    },
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
