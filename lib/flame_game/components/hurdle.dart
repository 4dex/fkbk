import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../hurdle_world.dart';

/// A [Hurdle] is an obstacle that moves from right to left across the screen.
/// The player must jump over it to avoid collision.
class Hurdle extends RectangleComponent with HasWorldReference<HurdleWorld> {
  
  Hurdle({super.position}) : super(
    size: Vector2(30, 120), // Width: 30, Height: 120
    anchor: Anchor.bottomLeft,
    paint: Paint()..color = Colors.red,
  );

  @override
  Future<void> onLoad() async {
    // Add a rectangular hitbox for collision detection
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move the hurdle to the left at the world's speed
    position.x -= world.speed * dt;

    // Remove the hurdle when it goes off-screen to the left
    if (position.x + size.x < -world.size.x / 2) {
      removeFromParent();
      // Increase score when a hurdle is successfully passed
      world.addScore();
    }
  }
}