import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import 'common/config.dart';
import 'entities/environment.dart';
import 'world/components/bird_component.dart';

class BirdGame extends FlameGame {
  final random = Random();

  @override
  Future<void> onLoad() async {
    final environment = Environment(
      birds: [],
      obstacles: [],
    );

    // Generate birds randomly
    List.generate(
      nbOfBirds,
      (index) {
        final dx = random.nextDouble() * environmentWidth;
        final dy = random.nextDouble() * environmentHeight;

        final bird = BirdComponent(
          id: index,
          environment: environment,
          velocity: Vector2(9, 0),
          fieldOfView: 180,
          distanceView: 200,
          collisionRange: 8,
          maxBearingChange: 3,
          maxSpeedChange: 1,
          maxSpeed: 15,
        )
          ..position = Vector2(dx, dy)
          ..size = Vector2.all(0.5);

        environment.birds.add(bird);
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
      // ..viewfinder.visibleGameSize =
      //     Vector2(environmentWidth as double, environmentHeight as double)
      // ..viewfinder.position = Vector2(0, 0)
      ..viewfinder.zoom = 1
      ..viewfinder.debugMode = true
      ..viewfinder.debugColor = const Color(0xFF00FF00);
    await add(cameraComponent);
  }
}
