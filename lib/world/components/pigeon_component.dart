import 'dart:ui';

import 'package:flutter/material.dart';

import '../../entities/pigeon.dart';

class PigeonComponent extends Pigeon {
  PigeonComponent({
    required super.id,
    required super.environment,
    required super.velocity,
    required super.fieldOfView,
    required super.distanceView,
    required super.collisionRange,
    required super.maxBearingChange,
    required super.maxSpeedChange,
    required super.maxSpeed,
  });

  @override
  bool get debugMode => false;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Position
    canvas.drawCircle(
      Offset.zero,
      1,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..strokeWidth = 1,
    );

    // Direction vector drawn.
    final n = velocity.normalized();
    canvas.drawLine(
      Offset.zero,
      Offset(n.x * 10, n.y * 10),
      Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  void action(double dt) {
    super.action(dt);
    position += velocity * dt;
  }
}
