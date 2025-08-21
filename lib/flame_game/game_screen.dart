import '../audio/audio_controller.dart';
import 'endless_runner.dart';
import 'hurdle_runner.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import 'game_win_dialog.dart';
import 'game_over_dialog.dart';

/// This widget defines the properties of the game screen.
///
/// It mostly sets up the overlays (widgets shown on top of the Flame game) and
/// the gets the [AudioController] from the context and passes it in to the
/// [EndlessRunner] class so that it can play audio.
class GameScreen extends StatelessWidget {
  const GameScreen({required this.level, super.key});

  final GameLevel level;

  static const String winDialogKey = 'win_dialog';
  static const String gameOverDialogKey = 'game_over_dialog';
  static const String backButtonKey = 'back_buttton';

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    
    // Choose the appropriate game based on the level's game type
    switch (level.gameType) {
      case GameType.hurdleJumping:
        return Scaffold(
          body: GameWidget<HurdleRunner>(
            key: const Key('hurdle game session'),
            game: HurdleRunner(
              level: level,
              playerProgress: context.read<PlayerProgress>(),
              audioController: audioController,
            ),
            overlayBuilderMap: {
              backButtonKey: (BuildContext context, HurdleRunner game) {
                return Positioned(
                  top: 20,
                  right: 10,
                  child: NesButton(
                    type: NesButtonType.normal,
                    onPressed: GoRouter.of(context).pop,
                    child: NesIcon(iconData: NesIcons.leftArrowIndicator),
                  ),
                );
              },
              winDialogKey: (BuildContext context, HurdleRunner game) {
                return GameWinDialog(
                  level: level,
                  levelCompletedIn: game.world.levelCompletedIn,
                );
              },
              gameOverDialogKey: (BuildContext context, HurdleRunner game) {
                return GameOverDialog(
                  level: level,
                  score: game.world.scoreNotifier.value,
                );
              },
            },
          ),
        );
      
      case GameType.endlessRunner:
      default:
        return Scaffold(
          body: GameWidget<EndlessRunner>(
            key: const Key('endless runner session'),
            game: EndlessRunner(
              level: level,
              playerProgress: context.read<PlayerProgress>(),
              audioController: audioController,
            ),
            overlayBuilderMap: {
              backButtonKey: (BuildContext context, EndlessRunner game) {
                return Positioned(
                  top: 20,
                  right: 10,
                  child: NesButton(
                    type: NesButtonType.normal,
                    onPressed: GoRouter.of(context).pop,
                    child: NesIcon(iconData: NesIcons.leftArrowIndicator),
                  ),
                );
              },
              winDialogKey: (BuildContext context, EndlessRunner game) {
                return GameWinDialog(
                  level: level,
                  levelCompletedIn: game.world.levelCompletedIn,
                );
              },
            },
          ),
        );
    }
  }
}
