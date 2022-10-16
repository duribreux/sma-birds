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
  });
}
