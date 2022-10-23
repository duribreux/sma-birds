import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'agent.dart';

abstract class Bird extends Agent {
  Vector2 velocity;
  final double fieldOfView;
  final double distanceView;
  final double collisionRange;
  final double maxBearingChange;
  final double maxSpeedChange;
  final double maxSpeed;
  final double cohesionFactor;
  final double separationFactor;
  final double alignmentFactor;

  Bird({
    required super.id,
    required super.environment,
    required this.velocity,
    required this.fieldOfView,
    required this.collisionRange,
    required this.distanceView,
    required this.maxBearingChange,
    required this.maxSpeedChange,
    required this.maxSpeed,
    required this.cohesionFactor,
    required this.separationFactor,
    required this.alignmentFactor,
  });

  Vector2 cohesion(Iterable<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    final center = birdsInSight.fold(
          Vector2(0, 0),
          (previousValue, element) => previousValue + element.position,
        ) /
        birdsInSight.length.toDouble();

    return (center - position) * cohesionFactor;
  }

  Vector2 separation(Iterable<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    var vector = Vector2(0, 0);

    for (final bird in birdsInSight) {
      final d = position.distanceTo(bird.position);
      if (d < collisionRange) {
        vector -= bird.position - position;
      }
    }

    return vector * separationFactor;
  }

  Vector2 alignment(Iterable<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    final averageVelocity = birdsInSight.fold(
          Vector2(0, 0),
          (previousValue, element) => previousValue + element.velocity,
        ) /
        birdsInSight.length.toDouble();

    return averageVelocity * alignmentFactor;
  }

  Vector2 limitSpeed() {
    if (velocity.length > maxSpeed) {
      velocity = (velocity / velocity.length) * maxSpeed;
    }

    return velocity;
  }

  Iterable<Bird> getBirdsInSight() => environment.birds.where(
        (element) =>
            element.id != id &&
            element.position.distanceTo(position) < distanceView &&
            element.position.angleTo(position) * 180 / pi < fieldOfView / 2,
      );
}
