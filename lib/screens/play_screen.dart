import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/game_state.dart';
import 'summary_screen.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  static const routeName = 'play';

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    if (!gameState.isRoundActive && gameState.lastResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.goNamed(SummaryScreen.routeName);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Round ${gameState.roundNumber}'),
        actions: [
          TextButton(
            onPressed: () {
              gameState.finishRound();
              context.goNamed(SummaryScreen.routeName);
            },
            child: const Text('End', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Time left'),
                    Text('${gameState.remaining.inSeconds}s',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Score'),
                    Text('${gameState.correct.length}',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      gameState.currentWord,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: gameState.markCorrect,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Correct (tilt down)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: gameState.markPass,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Pass (tilt up)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tilt down for correct, tilt up to pass. Sensors will be hooked up next.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
