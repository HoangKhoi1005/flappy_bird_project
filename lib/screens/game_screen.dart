import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';
import 'package:flappy_bird_project/widgets/game_over_menu.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FlappyBirdGame _game = FlappyBirdGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game view
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              'gameOverMenu': (context, game) {
                return GameOverMenu(
                  game: game as FlappyBirdGame,
                );
              },
            },
          ),

          // Score display
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<int>(
                stream: Stream.periodic(
                  const Duration(milliseconds: 100),
                  (_) => _game.score,
                ),
                builder: (context, snapshot) {
                  return Text(
                    'Điểm: ${snapshot.data ?? 0}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
