import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/game_state.dart';
import 'setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuessKaro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Choose one or more kid-friendly categories to play.'),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final category in gameState.availableCategories)
                    CheckboxListTile(
                      value: gameState.selectedCategories.contains(category),
                      title: Text(category),
                      onChanged: (_) => gameState.toggleCategory(category),
                    ),
                ],
              ),
            ),
            FilledButton(
              onPressed: gameState.hasSelection
                  ? () => context.goNamed(SetupScreen.routeName)
                  : null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 8),
                  Text('Continue to setup'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
