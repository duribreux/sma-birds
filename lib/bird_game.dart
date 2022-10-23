import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import 'entities/environment.dart';
import 'world/components/pigeon_component.dart';
import 'world/components/sparrow_component.dart';

class BirdGame extends FlameGame {
  final random = Random();

  @override
  Future<void> onLoad() async {
    final environment = Environment(
      birds: [],
    );

    // Generate birds randomly
    List.generate(
      200,
      (index) {
        final dx = random.nextDouble() * size.x;
        final dy = random.nextDouble() * size.y;

        if (random.nextBool()) {
          addPigeon(index, environment, dx, dy);
        } else {
          addSparrow(index, environment, dx, dy);
        }
      },
    );

    // Populate world
    final world = World();
    for (final bird in environment.birds) {
      await world.add(bird);
    }

    await add(world);

    final cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.topLeft
      ..viewfinder.visibleGameSize = size
      ..viewport.size = size;

    await add(cameraComponent);
  }

  void addPigeon(int index, Environment environment, double dx, double dy) {
    final bird = PigeonComponent(
      id: index,
      environment: environment,
      velocity: Vector2(
        random.nextDouble() * 9 * (random.nextBool() ? 1 : -1),
        random.nextDouble() * 9 * (random.nextBool() ? 1 : -1),
      ),
      fieldOfView: 230,
      distanceView: 50,
      collisionRange: 10,
      maxBearingChange: 0.15,
      maxSpeedChange: 2,
      maxSpeed: 15,
      cohesionFactor: 0.0004,
      separationFactor: 0.07,
      alignmentFactor: 0.04,
    )
      ..position = Vector2(dx, dy)
      ..anchor = Anchor.topLeft;

    environment.birds.add(bird);
  }

  void addSparrow(int index, Environment environment, double dx, double dy) {
    final bird = SparrowComponent(
      id: index,
      environment: environment,
      velocity: Vector2(
        random.nextDouble() * 13 * (random.nextBool() ? 1 : -1),
        random.nextDouble() * 13 * (random.nextBool() ? 1 : -1),
      ),
      fieldOfView: 180,
      distanceView: 40,
      collisionRange: 8,
      maxBearingChange: 0.2,
      maxSpeedChange: 2,
      maxSpeed: 18,
      cohesionFactor: 0.0005,
      separationFactor: 0.05,
      alignmentFactor: 0.05,
    )
      ..position = Vector2(dx, dy)
      ..anchor = Anchor.topLeft;

    environment.birds.add(bird);
  }
}
