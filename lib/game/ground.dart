import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flappy_bird_project/game/flappy_bird_game.dart';
import 'package:flappy_bird_project/game/bird.dart';
import 'package:flappy_bird_project/utils/constants.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Ground() : super(
    anchor: Anchor.bottomLeft, // Để định vị ở phía dưới của màn hình
    priority: 10, // Đặt priority cao để vẽ đè lên các thành phần khác
  );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background_down.png');
    final gameSize = gameRef.size;

    // Đặt vị trí và kích thước của ground
    position = Vector2(0, gameSize.y);
    width = gameSize.x;
    height = GameConstants.groundHeight;

    // Thêm hitbox để phát hiện va chạm
    final hitbox = RectangleHitbox()
      ..size = Vector2(width, height) // Sử dụng chiều cao đầy đủ của ground cho hitbox
      ..position = Vector2(0, 0);

    add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Đảm bảo ground luôn ở phía dưới màn hình
    position.y = gameRef.size.y;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bird) {
      gameRef.gameOver();
      gameRef.overlays.add('gameOverMenu');
    }
  }
}
