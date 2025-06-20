import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_bird_project/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class GameBackground extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    try {
      print('Loading background...');
      parallax = await Parallax.load(
        [ParallaxImageData('background.png')],
        baseVelocity: Vector2.zero(),
        velocityMultiplierDelta: Vector2.zero(),
        fill: LayerFill.height,
        repeat: ImageRepeat.repeat,
        alignment: Alignment.center,
      );
      print('Background loaded successfully');
    } catch (e) {
      print('Error loading background: $e');
    }
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    parallax?.resize(size);
  }
}
