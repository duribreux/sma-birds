import 'package:flame/components.dart';

import '../bird_game.dart';
import 'environment.dart';

abstract class Agent extends PositionComponent with HasGameRef<BirdGame> {
  final int id;
  final Environment environment;

  Agent({
    required this.id,
    required this.environment,
  });

  void action(double dt);

  @override
  void update(double dt) {
    action(dt);
    updatePositionInToricSpace();
    super.update(dt);
  }

  void updatePositionInToricSpace() {
    position
      ..x %= gameRef.size.x
      ..y %= gameRef.size.y;
  }
}
