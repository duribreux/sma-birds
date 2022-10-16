import 'package:flame/components.dart';

import 'bird.dart';

abstract class Pigeon extends Bird {
  Pigeon({
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
  void action(double dt) {
    final birdsInSight = getBirdsInSight();

    velocity += cohesion(birdsInSight.whereType<Pigeon>()) +
        separation(birdsInSight) +
        alignment(birdsInSight.whereType<Pigeon>());

    limitSpeed();
  }

  Vector2 limitSpeed() {
    if (velocity.length > maxSpeed) {
      velocity = (velocity / velocity.length) * maxSpeed;
    }

    return velocity;
  }

  Vector2 cohesion(Iterable<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    final center = birdsInSight.fold(
          Vector2(0, 0),
          (previousValue, element) => previousValue + element.position,
        ) /
        birdsInSight.length.toDouble();

    return (center - position) / 100;
  }

  Vector2 separation(Iterable<Bird> birdsInSight) {
    if (birdsInSight.isEmpty) {
      return Vector2(0, 0);
    }

    var c = Vector2(0, 0);

    for (final bird in birdsInSight) {
      final d = position.distanceTo(bird.position);
      if (d < collisionRange) {
        c -= bird.position - position;
      }
    }

    return c;
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

    return averageVelocity / 20;
  }
}
