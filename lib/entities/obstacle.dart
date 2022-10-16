import 'agent.dart';

abstract class Obstacle extends Agent {
  Obstacle({
    required super.id,
    required super.environment,
  });
}
