import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../common/config.dart';
import 'agent.dart';

abstract class Bird extends Agent {
  Vector2 velocity;
  final double fieldOfView;
  final double distanceView;
  final double collisionRange;
  final double maxBearingChange;
  final double maxSpeedChange;
  final double maxSpeed;

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
  });

  Iterable<Bird> getBirdsInSight() => environment.birds.where(
        (element) =>
            element.id != id &&
            element.position.distanceTo(position) < distanceView &&
            element.position.angleTo(position) * 180 / pi < fieldOfView / 2,
      );

  Vector2 bounds() {
    final v = Vector2(0, 0);

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

  Vector2 flyAwayFromPredators(Iterable<Bird> predators) {
    if (predators.isEmpty) {
      return Vector2(0, 0);
    }

    final predator = predators.first;
    final distance = predator.position.distanceTo(position);
    if (distance > 400) {
      return Vector2(0, 0);
    }

    final v = predator.position - position;

    return v;
  }
}
