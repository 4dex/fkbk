import '../level_selection/levels.dart';
import '../style/palette.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

/// This dialog is shown when the game is over (player hits a hurdle).
class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.level,
    required this.score,
  });

  /// The properties of the level that was being played.
  final GameLevel level;

  /// The score achieved before game over.
  final int score;

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return Center(
      child: NesContainer(
        width: 420,
        height: 280,
        backgroundColor: palette.backgroundPlaySession.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GAME OVER',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You jumped over $score hurdle${score == 1 ? '' : 's'}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You need ${level.winScore} to complete the level.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NesButton(
              onPressed: () {
                // Restart the same level
                context.go('/play/session/${level.number}');
              },
              type: NesButtonType.primary,
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 16),
            NesButton(
              onPressed: () {
                context.go('/play');
              },
              type: NesButtonType.normal,
              child: const Text('Level Selection'),
            ),
          ],
        ),
      ),
    );
  }
}