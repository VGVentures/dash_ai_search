import 'dart:async';
import 'dart:ui' as ui show Image;

import 'package:app_ui/app_ui.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

/// {@template sprites}
/// Object which contains meta data for a collection of sprites.
/// {@endtemplate}
class Sprites {
  /// {@macro sprites}
  const Sprites({
    required this.asset,
    required this.size,
    required this.frames,
    this.stepTime = 0.1,
  });

  /// The sprite sheet asset name.
  /// This should be the name of the file within
  /// the `assets/images` directory.
  final String asset;

  /// The size an individual sprite within the sprite sheet
  final Size size;

  /// The number of frames within the sprite sheet.
  final int frames;

  /// Number of seconds per frame. Defaults to 0.1.
  final double stepTime;
}

/// The animation mode which determines when the animation plays.
enum AnimationMode {
  /// Animations plays on a loop
  loop,

  /// Animations plays immediately once
  oneTime
}

/// {@template animated_sprite}
/// A widget which renders an animated sprite
/// given a collection of sprites.
/// {@endtemplate}
class AnimatedSprite extends StatefulWidget {
  /// {@macro animated_sprite}
  const AnimatedSprite({
    required this.sprites,
    super.key,
    this.mode = AnimationMode.loop,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor = Colors.white,
    this.onComplete,
  });

  /// The collection of sprites which will be animated.
  final Sprites sprites;

  /// The mode of animation (`trigger`, `loop` or `oneTime`).
  final AnimationMode mode;

  /// Where should display a loading indicator while loading the sprite
  final bool showLoadingIndicator;

  /// Color for loading indicator
  final Color loadingIndicatorColor;

  /// Callback when animation is completed.
  /// Only called if `mode` is not `loop`.
  final VoidCallback? onComplete;

  @override
  State<AnimatedSprite> createState() => _AnimatedSpriteState();
}

enum _AnimatedSpriteStatus { loading, loaded, failure }

extension on _AnimatedSpriteStatus {
  /// Returns true for `_AnimatedSpriteStatus.loaded`.
  bool get isLoaded => this == _AnimatedSpriteStatus.loaded;
}

class _AnimatedSpriteState extends State<AnimatedSprite> {
  late SpriteAnimation _animation;
  Timer? _timer;
  var _status = _AnimatedSpriteStatus.loading;
  var _isPlaying = false;
  late SpriteAnimationTicker _spriteAnimationTicker;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedSprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sprites != widget.sprites) {
      _loadAnimation();
    }
  }

  Future<void> _loadAnimation() async {
    late ui.Image image;
    try {
      final images = Flame.images..prefix = 'assets/animations/';
      image = await images.load(widget.sprites.asset);
    } catch (_) {
      setState(() => _status = _AnimatedSpriteStatus.failure);
      return;
    }

    _animation = SpriteSheet(
      image: image,
      srcSize: Vector2(widget.sprites.size.width, widget.sprites.size.height),
    ).createAnimation(
      row: 0,
      stepTime: widget.sprites.stepTime,
      to: widget.sprites.frames,
      loop: widget.mode == AnimationMode.loop,
    );
    _spriteAnimationTicker = _animation.createTicker();

    if (mounted) {
      setState(() {
        _status = _AnimatedSpriteStatus.loaded;
        if (widget.mode == AnimationMode.loop ||
            widget.mode == AnimationMode.oneTime) {
          _isPlaying = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedCrossFade(
      firstChild: widget.showLoadingIndicator
          ? SizedBox.fromSize(
              size: const Size(20, 20),
              child: AppCircularProgressIndicator(
                strokeWidth: 2,
                color: widget.loadingIndicatorColor,
              ),
            )
          : const SizedBox(),
      secondChild: SizedBox.expand(
        child: _status.isLoaded
            ? SpriteAnimationWidget(
                animation: _animation,
                playing: _isPlaying,
                animationTicker: _spriteAnimationTicker,
                onComplete: widget.onComplete,
              )
            : const SizedBox(),
      ),
      crossFadeState: _status.isLoaded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
