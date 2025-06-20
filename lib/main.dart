import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flappy_bird_project/screens/main_menu_screen.dart';

void main() async {
  // Đảm bảo Flutter được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Cố định hướng màn hình (chỉ cho phép chế độ dọc)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Ẩn thanh trạng thái (status bar) để game toàn màn hình
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const FlappyBirdApp());
}

class FlappyBirdApp extends StatelessWidget {
  const FlappyBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn banner debug
      title: 'Flappy Bird',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(), // Bắt đầu với màn hình menu chính
    );
  }
}
