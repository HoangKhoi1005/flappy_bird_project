import 'package:flutter/material.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';
import 'package:flappy_bird_project/screens/main_menu_screen.dart';
import 'package:flappy_bird_project/widgets/custom_button.dart';
import 'package:flappy_bird_project/utils/constants.dart';

class GameOverMenu extends StatelessWidget {
  final FlappyBirdGame game;

  const GameOverMenu({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 25.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: GameColors.gameOverColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Điểm: ${game.score}',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Điểm cao: ${game.playerData.highScore}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Chơi lại',
                    onTap: () {
                      game.startGame();
                      game.gameState.isGameOver = false;
                      game.overlays.remove('gameOverMenu');
                    },
                    width: 120,
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    text: 'Menu',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainMenuScreen(),
                        ),
                      );
                    },
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
