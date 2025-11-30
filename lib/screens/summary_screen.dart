import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/game_state.dart';
import 'home_screen.dart';
import 'play_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  static const routeName = 'summary';

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final result = gameState.lastResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Round summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: result == null
            ? const Center(child: Text('No round data yet.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Round ${result.roundNumber}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Correct: ${result.correct.length}  •  Passed: ${result.passed.length}'),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text('Correct guesses'),
                        Wrap(
                          spacing: 8,
                          children: result.correct
                              .map((word) => Chip(label: Text(word)))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Passed words'),
                        Wrap(
                          spacing: 8,
                          children: result.passed
                              .map((word) => Chip(label: Text(word)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      await gameState.prepareRound();
                      if (context.mounted) {
                        context.goNamed(PlayScreen.routeName);
                      }
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Play again'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.goNamed(HomeScreen.routeName),
                    icon: const Icon(Icons.home),
                    label: const Text('Change categories'),
                  ),
                ],
              ),
      ),
    );
  }
}
