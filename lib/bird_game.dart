import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import 'common/config.dart';
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
      nbOfBirds,
      (index) {
        var dx = random.nextDouble() * environmentWidth;
        var dy = random.nextDouble() * environmentHeight;

        if (random.nextBool()) {
          dx *= -1;
        }

        if (random.nextBool()) {
          dy *= -1;
        }

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

    // Add camera
    final cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.topLeft
      ..viewfinder.zoom = 0.5;

    await add(cameraComponent);
  }

  void addPigeon(int index, Environment environment, double dx, double dy) {
    final bird = PigeonComponent(
      id: index,
      environment: environment,
      velocity: Vector2(
        random.nextDouble() * 9,
        random.nextDouble() * 9,
      ),
      fieldOfView: 230,
      distanceView: 160,
      collisionRange: 5,
      maxBearingChange: 1,
      maxSpeedChange: 1,
      maxSpeed: 12,
    )
      ..position = Vector2(dx, dy)
      ..size = Vector2.all(0.5);

    environment.birds.add(bird);
  }

  void addSparrow(int index, Environment environment, double dx, double dy) {
    final bird = SparrowComponent(
      id: index,
      environment: environment,
      velocity: Vector2(
        random.nextDouble() * 13,
        random.nextDouble() * 13,
      ),
      fieldOfView: 180,
      distanceView: 200,
      collisionRange: 3,
      maxBearingChange: 3,
      maxSpeedChange: 2,
      maxSpeed: 20,
    )
      ..position = Vector2(dx, dy)
      ..size = Vector2.all(0.5);

    environment.birds.add(bird);
  }
}
