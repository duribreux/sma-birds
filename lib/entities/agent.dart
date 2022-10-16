import 'package:flame/components.dart';

import '../common/config.dart';
import 'environment.dart';

abstract class Agent extends PositionComponent {
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
  }

  void updatePositionInToricSpace() {
    position
      ..x %= environmentWidth
      ..y %= environmentHeight;
  }
}
