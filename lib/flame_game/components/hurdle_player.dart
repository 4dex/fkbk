import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../audio/sounds.dart';
import '../endless_runner.dart';
import '../hurdle_world.dart';
import 'hurdle.dart';

/// The [HurdlePlayer] is a simple dot that can jump over hurdles.
/// Unlike the regular player, this one stays in place horizontally
/// while hurdles move toward it.
class HurdlePlayer extends CircleComponent
    with CollisionCallbacks, HasWorldReference<HurdleWorld>, HasGameReference<EndlessRunner> {
  
  HurdlePlayer({super.position}) : super(
    radius: 25,
    anchor: Anchor.center,
    priority: 1,
    paint: Paint()..color = Colors.blue,
  );

  // The current velocity that the player has from gravity and jumping
  double _velocityY = 0;

  // Jump strength - how much upward velocity is applied when jumping
  final double _jumpStrength = 800;

  // Whether the player is currently on the ground
  bool get isOnGround => (position.y + radius) >= world.groundLevel;

  // Whether the player is currently jumping (has upward velocity)
  bool get isJumping => _velocityY < 0;

  @override
  Future<void> onLoad() async {
    // Add a circular hitbox for collision detection
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Apply gravity when in the air
    if (!isOnGround) {
      _velocityY += world.gravity * dt;
      position.y += _velocityY * dt;
    }

    // Check if player has landed on the ground
    if (position.y + radius > world.groundLevel) {
      position.y = world.groundLevel - radius;
      _velocityY = 0;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    // When the player collides with a hurdle, trigger game over
    if (other is Hurdle) {
      game.audioController.playSfx(SfxType.damage);
      world.gameOver();
    }
  }

  /// Make the player jump if they're on the ground
  void jump() {
    if (isOnGround) {
      game.audioController.playSfx(SfxType.jump);
      _velocityY = -_jumpStrength;
    }
  }
}