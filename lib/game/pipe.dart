import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';
import 'package:flappy_bird_project/utils/constants.dart';
import 'package:flappy_bird_project/game/bird.dart';

class Pipe extends PositionComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  bool passed = false;
  final Random _random = Random();
  late SpriteComponent topPipe;
  late SpriteComponent bottomPipe;

  Pipe() : super(
    priority: 5, // Đặt priority thấp hơn Ground (10)
  );

  @override
  Future<void> onLoad() async {
    // Vị trí bắt đầu (bên phải màn hình)
    position.x = gameRef.size.x;

    // Tạo ống trên
    topPipe = SpriteComponent(
      sprite: await Sprite.load('pipe_top.png'),
    );

    // Tạo ống dưới
    bottomPipe = SpriteComponent(
      sprite: await Sprite.load('pipe_bottom.png'),
    );

    // Đặt kích thước cố định cho ống
    topPipe.width = 90;
    topPipe.height = 720; // Sử dụng chiều cao gốc của hình ảnh ống

    bottomPipe.width = 90;
    bottomPipe.height = 720; // Sử dụng chiều cao gốc của hình ảnh ống

    // Tính toán khoảng cách an toàn từ các cạnh màn hình
    final topSafeMargin = 100.0;  // Khoảng cách từ cạnh trên
    final bottomSafeMargin = 150.0;  // Khoảng cách từ cạnh dưới (lớn hơn để tránh mặt đất)

    // Tính toán vị trí hợp lệ cho khoảng trống giữa hai ống
    final minPosition = topSafeMargin;
    final maxPosition = gameRef.size.y - GameConstants.pipeGap - bottomSafeMargin;

    // Đảm bảo minPosition < maxPosition để tránh lỗi
    final validMaxPosition = max(minPosition + 50, maxPosition);

    // Tính toán vị trí ngẫu nhiên giới hạn trong khoảng an toàn
    final pipeGapPosition = minPosition + _random.nextDouble() * (validMaxPosition - minPosition);


    // Đặt vị trí cho ống trên (phải di chuyển lên trên để tạo khoảng trống)
    // Sử dụng Anchor.bottomLeft để đáy của ống trên sẽ ở vị trí pipeGapPosition
    topPipe.position = Vector2(0, pipeGapPosition);
    topPipe.anchor = Anchor.bottomLeft;

    // Đặt vị trí cho ống dưới
    // Sử dụng Anchor.topLeft để đỉnh của ống dưới sẽ ở vị trí pipeGapPosition + khoảng cách
    bottomPipe.position = Vector2(0, pipeGapPosition + GameConstants.pipeGap);
    bottomPipe.anchor = Anchor.topLeft;

    // Thêm hitbox cho ống trên với kích thước nhỏ hơn
    final topHitbox = RectangleHitbox()
      ..size = Vector2(topPipe.width * 0.9, topPipe.height * 0.95)
      ..position = Vector2(topPipe.width * 0.05, 0);
    topPipe.add(topHitbox);

    // Thêm hitbox cho ống dưới với kích thước nhỏ hơn
    final bottomHitbox = RectangleHitbox()
      ..size = Vector2(bottomPipe.width * 0.9, bottomPipe.height * 0.95)
      ..position = Vector2(bottomPipe.width * 0.05, 0);
    bottomPipe.add(bottomHitbox);

    // Thêm ống vào màn hình
    add(topPipe);
    add(bottomPipe);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.gameState.isPlaying) return;

    // Di chuyển ống sang trái
    position.x -= GameConstants.pipeSpeed * dt;

    // Kiểm tra nếu ống đã qua vị trí con chim để tính điểm
    if (!passed && position.x < gameRef.bird.position.x - topPipe.width) {
      passed = true;
      gameRef.increaseScore();
    }

    // Xóa ống khi ra khỏi màn hình
    if (position.x < -topPipe.width) {
      removeFromParent();
      gameRef.pipes.remove(this);
    }
  }
}
