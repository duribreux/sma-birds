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
    required super.cohesionFactor,
    required super.separationFactor,
    required super.alignmentFactor,
  });

  @override
  void action(double dt) {
    final birdsInSight = getBirdsInSight();

    velocity += cohesion(birdsInSight.whereType<Pigeon>()) +
        separation(birdsInSight) +
        alignment(birdsInSight.whereType<Pigeon>());

    limitSpeed();
  }
}
