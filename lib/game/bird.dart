import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';
import 'package:flappy_bird_project/utils/constants.dart';
import 'package:flappy_bird_project/game/pipe.dart';

class Bird extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double targetAngle = 0;
  bool hasCollided = false; // Thêm biến để theo dõi đã va chạm hay chưa
  bool isFalling = false; // Thêm trạng thái đang rơi

  Bird() : super(
    size: Vector2(GameConstants.birdSize, GameConstants.birdSize),
    anchor: Anchor.center, // xoay quanh tâm
    priority: 15, // Đặt priority cao để vẽ đè lên các thành phần khác
  );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);

    // Sử dụng hitbox hình tròn với bán kính nhỏ hơn để va chạm chính xác hơn
    final hitbox = CircleHitbox(
      radius: size.x / 7.0, // Giảm bán kính nhiều hơn để phù hợp với hình dạng thực tế
      position: size / 2, // Đặt vị trí hitbox ở giữa con chim
      anchor: Anchor.center,
    );
    add(hitbox);

    // Debug để xem hitbox (xóa khi release)
    // add(RectangleComponent(
    //   size: Vector2(hitbox.radius * 2, hitbox.radius * 2),
    //   position: size / 2,
    //   anchor: Anchor.center,
    //   paint: Paint()..color = const Color(0x44FF0000),
    // ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Cho phép chim tiếp tục rơi ngay cả khi game đã kết thúc nhưng chưa chạm đất
    if (isFalling && hasCollided) {
      velocity.y += GameConstants.gravity * dt;
      position.y += velocity.y * dt;

      // Tăng tốc độ rơi sau khi va chạm
      velocity.y = math.min(velocity.y, GameConstants.gravity * 2);

      // Xoay chim đầu xuống khi rơi
      targetAngle = math.min(math.pi / 2, angle + dt * 5);
      angle = angle + (targetAngle - angle) * GameConstants.rotationSmoothing * dt * 2;

      // Kiểm tra chim chạm đất
      // Sử dụng vị trí của ground (gameRef.size.y - GameConstants.groundHeight)
      // và đặt tâm chim (anchor.center) đúng vị trí trên ground
      if (position.y > gameRef.size.y - GameConstants.groundHeight ) {
        position.y = gameRef.size.y - GameConstants.groundHeight ;
        if (gameRef.gameState.isGameOver) {
          // Hiển thị menu game over
          gameRef.overlays.add('gameOverMenu');
        }
        isFalling = false; // Dừng rơi khi chạm đất
      }
      return;
    }

    if (!gameRef.gameState.isPlaying) return;

    velocity.y += GameConstants.gravity * dt;
    position.y += velocity.y * dt;

    // Cập nhật trạng thái isFalling
    isFalling = velocity.y > 0;

    // Góc mục tiêu dựa trên vận tốc
    targetAngle = velocity.y < 0
        ? -math.pi / 6
        : (velocity.y * 0.001).clamp(0, math.pi / 3);

    // Nội suy góc mượt mà
    angle = angle + (targetAngle - angle) * GameConstants.rotationSmoothing * dt;
  }

  void flap() {

    velocity.y = -GameConstants.birdVelocity;
    targetAngle = -math.pi / 6;
  }

  void reset() {
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);
    velocity.setZero();
    angle = 0;
    hasCollided = false; // Reset trạng thái va chạm
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Chỉ phát hiện va chạm với thành phần của ống và chỉ xử lý nếu chưa va chạm
    if (!hasCollided && other is SpriteComponent && other.parent is Pipe) {
      hasCollided = true; // Đánh dấu đã va chạm
      isFalling = true; // Bắt đầu trạng thái rơi
      gameRef.gameOver();

      // Dừng chim ngay lập tức khi
      velocity.y = math.max(velocity.y, 100); // Đảm bảo vận tốc rơi dương
    }
  }
}
