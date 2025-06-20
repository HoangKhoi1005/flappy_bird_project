import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird_project/game/bird.dart';
import 'package:flappy_bird_project/game/pipe.dart';
import 'package:flappy_bird_project/game/background.dart';
import 'package:flappy_bird_project/game/ground.dart';
import 'package:flappy_bird_project/game/flash_effect.dart';
import 'package:flappy_bird_project/models/game_state.dart';
import 'package:flappy_bird_project/models/player_data.dart';
import 'package:flappy_bird_project/utils/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  // Game components
  late Bird bird;
  late GameBackground background;
  late Ground ground; // Thêm ground component

  // Game state and player data
  final GameState gameState = GameState();
  final PlayerData playerData = PlayerData();

  // Audio
  final AudioPlayer audioPlayer = AudioPlayer();

  // Pipes
  final List<Pipe> pipes = [];
  double pipeSpawnTimer = 0;
  int score = 0;


  @override
  Future<void> onLoad() async {
    try {
      // In ra kích thước game để debug
      print('Game size: $size');

      // Load background trước
      print('Loading background...');
      background = GameBackground();
      add(background);
      print('Background added successfully');

      // Load bird
      print('Loading bird...');
      bird = Bird();
      add(bird);
      print('Bird added successfully');

      // Load ground
      print('Loading ground...');
      ground = Ground();
      add(ground);
      print('Ground added successfully');

      // Initialize game state
      gameState.isPlaying = false;

      // Load player data
      await playerData.loadFromStorage();

      // Initialize audio
      // audioPlayer.setSource(AssetSource('audio/flap.wav'));

      print('Game loaded successfully');
    } catch (e) {
      print('Error loading game components: $e');
      // In stack trace để dễ debug
      print(StackTrace.current);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameState.isPlaying) return;

    // Update pipe spawn timer
    pipeSpawnTimer += dt;
    if (pipeSpawnTimer >= GameConstants.pipeInterval) {
      spawnPipe();
      pipeSpawnTimer = 0;
    }

    // Check for out of bounds
    if (bird.position.y > size.y || bird.position.y < 0) {
      gameOver();
    }
  }

  @override
  void onTap() {
    if (!gameState.isPlaying) {
      startGame();
      overlays.remove('gameOverMenu');
    } else {
      bird.flap();
      // audioPlayer.resume();
    }
  }

  void startGame() {
    gameState.isPlaying = true;

    score = 0;
    bird.reset();

    // Clear existing pipes
    for (var pipe in pipes) {
      pipe.removeFromParent();
    }
    pipes.clear();

    // Reset spawn timer
    pipeSpawnTimer = 0;
  }

  void gameOver() {
    gameState.isPlaying = false;

    // Hiển thị hiệu ứng flash khi va chạm
    add(FlashEffect());

    // Update player data
    playerData.lastScore = score;
    if (score > playerData.highScore) {
      playerData.highScore = score;
    }
    playerData.gamesPlayed++;
    playerData.saveToStorage();

    gameState.isGameOver = true;

    // Không hiển thị menu game over ngay lập tức
    // Sẽ hiển thị khi chim chạm đất (được xử lý trong Bird.update)
  }

  void spawnPipe() {
    final pipe = Pipe();
    add(pipe);
    pipes.add(pipe);
  }

  void increaseScore() {
    score++;
    // Play point sound
    // audioPlayer.setSource(AssetSource('audio/point.wav'));
    // audioPlayer.resume();
  }
}
