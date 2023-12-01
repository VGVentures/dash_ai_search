import 'package:flame/cache.dart';
import 'package:flame/components.dart';

class DashAnimations {
  DashAnimations({
    Images? images,
  }) {
    _images = images ?? Images(prefix: 'assets/animations/');
  }

  late final Images _images;

  Images get images => _images;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation waveAnimation;
  late final SpriteAnimation happyAnimation;
  late final SpriteAnimation sadAnimation;
  late final SpriteAnimation thinkingAnimation;

  Future<void> load() async {
    final [idle, wave, happy, sad, thinking] = await Future.wait([
      _images.load('dash_idle_animation.png'),
      _images.load('dash_wave_animation.png'),
      _images.load('dash_happy_animation.png'),
      _images.load('dash_sad_animation.png'),
      _images.load('dash_thinking_animation.png'),
    ]);

    idleAnimation = SpriteAnimation.fromFrameData(
      idle,
      SpriteAnimationData.sequenced(
        amount: 12,
        amountPerRow: 4,
        stepTime: 0.07,
        textureSize: Vector2.all(1500),
      ),
    );

    waveAnimation = SpriteAnimation.fromFrameData(
      wave,
      SpriteAnimationData.sequenced(
        amount: 25,
        amountPerRow: 5,
        stepTime: 0.07,
        textureSize: Vector2.all(1500),
        loop: false,
      ),
    );

    happyAnimation = SpriteAnimation.fromFrameData(
      happy,
      SpriteAnimationData.sequenced(
        amount: 12,
        amountPerRow: 4,
        stepTime: 0.07,
        textureSize: Vector2.all(1500),
        loop: false,
      ),
    );

    sadAnimation = SpriteAnimation.fromFrameData(
      sad,
      SpriteAnimationData.sequenced(
        amount: 12,
        amountPerRow: 4,
        stepTime: 0.07,
        textureSize: Vector2.all(1500),
        loop: false,
      ),
    );

    thinkingAnimation = SpriteAnimation.fromFrameData(
      thinking,
      SpriteAnimationData.sequenced(
        amount: 12,
        amountPerRow: 4,
        stepTime: 0.07,
        textureSize: Vector2.all(1500),
        loop: false,
      ),
    );
  }
}
