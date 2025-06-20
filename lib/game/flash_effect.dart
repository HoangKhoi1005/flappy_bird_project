import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';

class FlashEffect extends RectangleComponent with HasGameRef<FlappyBirdGame> {
  FlashEffect() : super(
    paint: Paint()..color = Colors.white.withOpacity(0.7),
    priority: 20, // Đặt priority cao nhất để hiển thị trên tất cả các thành phần khác
  );

  @override
  Future<void> onLoad() async {
    size = gameRef.size; // Kích thước bằng toàn bộ màn hình
    position = Vector2.zero(); // Vị trí ở góc trên bên trái

    // Thêm hiệu ứng opacity để tạo hiệu ứng flash nhanh (chóp nhanh)
    final fadeEffect = OpacityEffect.fadeOut(
      LinearEffectController(0.2), // Thời gian hiệu ứng: 0.2 giây
      onComplete: () => removeFromParent(), // Xóa component sau khi hiệu ứng kết thúc
    );

    add(fadeEffect);

    return super.onLoad();
  }
}
