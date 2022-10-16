import 'bird.dart';
import 'obstacle.dart';

class Environment {
  final List<Bird> birds;
  final List<Obstacle> obstacles;

  Environment({
    required this.birds,
    required this.obstacles,
  });
}
