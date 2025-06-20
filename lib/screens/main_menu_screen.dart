import 'package:flutter/material.dart';
import 'package:flappy_bird_project/screens/game_screen.dart';
import 'package:flappy_bird_project/widgets/custom_button.dart';
import 'package:flappy_bird_project/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _highScore = 0;
  int _gamesPlayed = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Tải dữ liệu điểm cao và số trận đã chơi
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt(StorageKeys.highScore) ?? 0;
      _gamesPlayed = prefs.getInt(StorageKeys.gamesPlayed) ?? 0;
    });
  }

  // Bắt đầu game mới
  void _startGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: GameColors.menuBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flappy Bird',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/bird.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 50),
            Text(
              'Điểm cao: $_highScore',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Số trận đã chơi: $_gamesPlayed',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            CustomButton(
              onTap: _startGame,
              text: 'Bắt Đầu',
            ),
          ],
        ),
      ),
    );
  }
}
