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
}
