import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A simple red background for the hurdle jumping game.
/// This provides a solid red background instead of the parallax scenery.
class RedBackground extends RectangleComponent {
  RedBackground() : super(
    paint: Paint()..color = Colors.red[600]!,
  );

  @override
  Future<void> onLoad() async {
    // Make the background cover the entire game area
    size = (parent as HasGameRef).game.size;
    position = Vector2.zero();
    anchor = Anchor.topLeft;
  }
}