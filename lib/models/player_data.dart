import 'package:shared_preferences/shared_preferences.dart';
import 'package:flappy_bird_project/utils/constants.dart';

class PlayerData {
  int highScore = 0;
  int lastScore = 0;
  int gamesPlayed = 0;

  // Tải dữ liệu từ bộ nhớ
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(StorageKeys.highScore) ?? 0;
    lastScore = prefs.getInt(StorageKeys.lastScore) ?? 0;
    gamesPlayed = prefs.getInt(StorageKeys.gamesPlayed) ?? 0;
  }

  // Lưu dữ liệu vào bộ nhớ
  Future<void> saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.highScore, highScore);
    await prefs.setInt(StorageKeys.lastScore, lastScore);
    await prefs.setInt(StorageKeys.gamesPlayed, gamesPlayed);
  }

  // Reset dữ liệu
  Future<void> resetData() async {
    highScore = 0;
    lastScore = 0;
    gamesPlayed = 0;
    await saveToStorage();
  }
}
