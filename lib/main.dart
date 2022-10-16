import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'bird_game.dart';

void main() {
  final game = BirdGame();
  runApp(GameWidget(game: game));
}
