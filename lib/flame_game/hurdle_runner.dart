import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'components/red_background.dart';
import 'hurdle_world.dart';

/// The [HurdleRunner] is the main game class for the hurdle jumping game.
/// Similar to EndlessRunner but uses HurdleWorld instead of EndlessWorld.
class HurdleRunner extends FlameGame<HurdleWorld> with HasCollisionDetection {
  HurdleRunner({
    required this.level,
    required PlayerProgress playerProgress,
    required this.audioController,
  }) : super(
          world: HurdleWorld(level: level, playerProgress: playerProgress),
          camera: CameraComponent.withFixedResolution(width: 1600, height: 720),
        );

  /// What the properties of the level that is played has.
  final GameLevel level;

  /// A helper for playing sound effects and background audio.
  final AudioController audioController;

  @override
  Future<void> onLoad() async {
    // Add the red background for hurdle jumping
    camera.backdrop.add(RedBackground());

    // Set up the score text renderer
    final textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontFamily: 'Press Start 2P',
      ),
    );

    final scoreText = 'Hurdles: 0 / ${level.winScore}';

    // Create the score component
    final scoreComponent = TextComponent(
      text: scoreText,
      position: Vector2.all(30),
      textRenderer: textRenderer,
    );

    // Add the score component to the viewport
    camera.viewport.add(scoreComponent);

    // Listen for score updates
    world.scoreNotifier.addListener(() {
      scoreComponent.text =
          scoreText.replaceFirst('0', '${world.scoreNotifier.value}');
    });
  }
}