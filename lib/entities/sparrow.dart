import 'bird.dart';

abstract class Sparrow extends Bird {
  Sparrow({
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

    velocity += cohesion(birdsInSight.whereType<Sparrow>()) +
        separation(birdsInSight) +
        alignment(birdsInSight.whereType<Sparrow>());

    limitSpeed();
  }
}
