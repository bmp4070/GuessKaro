import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/game_state.dart';
import 'play_screen.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  static const routeName = 'setup';

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Round setup'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Round timer'),
            subtitle: const Text('How long should each round last?'),
            trailing: DropdownButton<int>(
              value: gameState.roundDuration.inSeconds,
              items: const [60, 90, 120]
                  .map(
                    (seconds) => DropdownMenuItem(
                      value: seconds,
                      child: Text('${seconds}s'),
                    ),
                  )
                  .toList(),
              onChanged: (seconds) {
                if (seconds == null) return;
                gameState.setRoundDuration(Duration(seconds: seconds));
              },
            ),
          ),
          SwitchListTile(
            title: const Text('High contrast'),
            value: gameState.highContrast,
            onChanged: gameState.toggleHighContrast,
            subtitle: const Text('Uses a darker theme to boost contrast.'),
          ),
          SwitchListTile(
            title: const Text('Large text'),
            value: gameState.largeText,
            onChanged: gameState.toggleLargeText,
            subtitle: const Text('Scales text for easier reading.'),
          ),
          SwitchListTile(
            title: const Text('Mute sounds'),
            value: gameState.mute,
            onChanged: gameState.toggleMute,
            subtitle: const Text('Disable celebratory sounds during play.'),
          ),
          SwitchListTile(
            title: const Text('Haptics'),
            value: gameState.haptics,
            onChanged: gameState.toggleHaptics,
            subtitle: const Text('Vibration feedback on correct/pass.'),
          ),
          ListTile(
            title: const Text('Rounds per session'),
            trailing: DropdownButton<int>(
              value: gameState.roundCount,
              items: const [1, 3, 5]
                  .map(
                    (count) => DropdownMenuItem(value: count, child: Text('$count')),
                  )
                  .toList(),
              onChanged: (count) {
                if (count == null) return;
                gameState.setRoundCount(count);
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await gameState.prepareRound();
              if (context.mounted) {
                context.goNamed(PlayScreen.routeName);
              }
            },
            icon: const Icon(Icons.play_circle),
            label: const Text('Start round'),
          ),
        ],
      ),
    );
  }
}
