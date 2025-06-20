import 'package:flutter/material.dart';

class GameConstants {
  static const double pipeSpeed = 150.0;
  static const double birdVelocity = 350.0;
  static const double gravity = 980.0;

  static const double pipeInterval = 1.7;
  static const double pipeGap = 200.0;

  static const double birdSize = 110.0;

  static const double flapAnimationDuration = 0.2;
  static const double rotationSmoothing = 6.0;
  static const double groundHeight = 100.0;
}

class GameColors {
  static const Color background = Color(0xFF70C5CE);
  static const Color menuBackground = Color(0xFF76C2AF);
  static const Color buttonColor = Color(0xFFDDE04E);
  static const Color scoreColor = Colors.white;
  static const Color gameOverColor = Colors.red;
}

class StorageKeys {
  static const String highScore = 'highScore';
  static const String lastScore = 'lastScore';
  static const String gamesPlayed = 'gamesPlayed';
}
