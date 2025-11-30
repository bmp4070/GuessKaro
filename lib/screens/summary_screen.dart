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
                        _WordSection(
                          title: 'Correct (${result.correct.length})',
                          words: result.correct,
                          emptyLabel: 'No correct guesses this round.',
                        ),
                        const SizedBox(height: 12),
                        _WordSection(
                          title: 'Passed (${result.passed.length})',
                          words: result.passed,
                          emptyLabel: 'No passes this round.',
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

class _WordSection extends StatelessWidget {
  const _WordSection({
    required this.title,
    required this.words,
    required this.emptyLabel,
  });

  final String title;
  final List<String> words;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (words.isEmpty)
              Text(
                emptyLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: words.map((word) => Chip(label: Text(word))).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
