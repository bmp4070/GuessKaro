import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'state/game_state.dart';

class GuessKaroApp extends StatefulWidget {
  const GuessKaroApp({super.key});

  @override
  State<GuessKaroApp> createState() => _GuessKaroAppState();
}

class _GuessKaroAppState extends State<GuessKaroApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        final theme = ThemeData(
          brightness: gameState.highContrast ? Brightness.dark : Brightness.light,
          colorSchemeSeed: Colors.teal,
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: gameState.largeText ? 1.2 : 1.0,
              ),
          useMaterial3: true,
        );

        return MaterialApp.router(
          title: 'GuessKaro',
          theme: theme,
          routerConfig: _router,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final scale = gameState.largeText ? 1.2 : 1.0;
            return MediaQuery(
              data: media.copyWith(textScaleFactor: media.textScaleFactor * scale),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
