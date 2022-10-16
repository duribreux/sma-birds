import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../entities/bird.dart';

class BirdComponent extends Bird {
  BirdComponent({
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
      Offset(position.x, position.y),
      1,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..strokeWidth = 1,
    );

    // Direction vector drawn.
    final n = velocity.normalized();
    canvas.drawLine(
      Offset(position.x, position.y),
      Offset(position.x + n.x * 10, position.y + n.y * 10),
      Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    if (id == 0) {
      // View distance
      canvas.drawCircle(
        Offset(position.x, position.y),
        distanceView,
        Paint()
          ..color = const Color(0x90FFFFFF)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );

      // Collision range
      canvas.drawCircle(
        Offset(position.x, position.y),
        collisionRange,
        Paint()
          ..color = const Color(0x90FF0000)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  void action(double dt) {
    final birdsInSight = environment.birds
        .where(
          (element) =>
              element.id != id &&
              element.position.distanceTo(position) < distanceView &&
              element.position.angleTo(position) < fieldOfView / 2,
        )
        .toList();

    velocity += _cohesion(birdsInSight) +
        _separation(birdsInSight) +
        _alignment(birdsInSight) +
        _bounds();

    _limitSpeed();

    position += velocity * dt * 10;
  }

  Vector2 _limitSpeed() {
    if (velocity.length > maxSpeed) {
      velocity = (velocity / velocity.length) * maxSpeed;
    }

    return velocity;
  }

  Vector2 _cohesion(List<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    final center = birdsInSight.fold(
          Vector2(0, 0),
          (previousValue, element) => previousValue + element.position,
        ) /
        (birdsInSight.length as double);

    return (center - position) / 100;
  }

  Vector2 _separation(List<Bird> birdsInSight) {
    var c = Vector2(0, 0);

    for (final bird in birdsInSight) {
      final d = position.distanceTo(bird.position);
      if (d < collisionRange) {
        c -= bird.position - position;
      }
    }

    return c;
  }

  Vector2 _alignment(List<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    final averageVelocity = birdsInSight.fold(
          Vector2(0, 0),
          (previousValue, element) => previousValue + element.velocity,
        ) /
        (birdsInSight.length as double);

    return averageVelocity / 20;
  }

  Vector2 _bounds() {
    var v = Vector2(0, 0);
    if (position.x < 0) {
      v.x += maxBearingChange;
    } else if (position.x > environmentWidth) {
      v.x += -maxBearingChange;
    }

    if (position.y < 0) {
      v.y += maxBearingChange;
    } else if (position.y > environmentHeight) {
      v.y += -maxBearingChange;
    }

    return v;
  }
}
