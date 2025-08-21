import 'dart:math';

import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/hurdle.dart';
import 'components/hurdle_player.dart';
import 'game_screen.dart';

/// The [HurdleWorld] is a specialized world for the hurdle jumping game.
/// In this variant, the player (a dot) stays in place while hurdles move 
/// toward them from the right. The player must jump to avoid collision.
class HurdleWorld extends World with TapCallbacks, HasGameReference {
  HurdleWorld({
    required this.level,
    required this.playerProgress,
    Random? random,
  }) : _random = random ?? Random();

  /// The properties of the current level.
  final GameLevel level;

  /// Used to see what the current progress of the player is and to update the
  /// progress if a level is finished.
  final PlayerProgress playerProgress;

  /// The speed at which hurdles move toward the player
  late double speed = _calculateSpeed(level.number);

  /// Track the current score (number of hurdles successfully jumped)
  final scoreNotifier = ValueNotifier(0);
  
  late final HurdlePlayer player;
  late final DateTime timeStarted;
  Vector2 get size => (parent as FlameGame).size;
  int levelCompletedIn = 0;
  
  /// Whether the game is over
  bool _gameOver = false;

  /// The random number generator used for spawning hurdles
  final Random _random;

  /// The gravity is defined in virtual pixels per second squared
  final double gravity = 1500;

  /// Where the ground is located in the world
  late final double groundLevel = (size.y / 2) - (size.y / 5);

  @override
  Future<void> onLoad() async {
    timeStarted = DateTime.now();

    // Create the player dot positioned on the left side of the screen
    player = HurdlePlayer(
      position: Vector2(-size.x / 3, groundLevel - 25), // 25 is the radius
    );
    add(player);

    // Spawn hurdles periodically from the right side
    add(
      SpawnComponent(
        factory: (_) => Hurdle(),
        period: 2.5, // Spawn a hurdle every 2.5 seconds
        area: Rectangle.fromPoints(
          Vector2(size.x / 2, groundLevel),
          Vector2(size.x / 2, groundLevel),
        ),
        random: _random,
      ),
    );

    // Listen for score changes to check win condition
    scoreNotifier.addListener(() {
      if (scoreNotifier.value >= level.winScore) {
        final levelTime = (DateTime.now().millisecondsSinceEpoch -
                timeStarted.millisecondsSinceEpoch) /
            1000;

        levelCompletedIn = levelTime.round();
        playerProgress.setLevelFinished(level.number, levelCompletedIn);
        game.pauseEngine();
        game.overlays.add(GameScreen.winDialogKey);
      }
    });
  }

  @override
  void onMount() {
    super.onMount();
    game.overlays.add(GameScreen.backButtonKey);
  }

  @override
  void onRemove() {
    game.overlays.remove(GameScreen.backButtonKey);
    game.overlays.remove(GameScreen.gameOverDialogKey);
  }

  /// Increase the score (called when a hurdle is successfully passed)
  void addScore({int amount = 1}) {
    if (!_gameOver) {
      scoreNotifier.value += amount;
    }
  }

  /// Trigger game over state
  void gameOver() {
    if (!_gameOver) {
      _gameOver = true;
      game.pauseEngine();
      game.overlays.add(GameScreen.gameOverDialogKey);
    }
  }

  /// Handle tap events to make the player jump
  @override
  void onTapDown(TapDownEvent event) {
    if (!_gameOver) {
      player.jump();
    }
  }

  /// Calculate the speed based on level number
  static double _calculateSpeed(int level) => 300 + (level * 100);
}