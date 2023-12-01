import 'dart:math' as math;
import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Bubble {
  Bubble({
    required this.position,
    required this.pathLength,
    required this.emoji,
    required this.size,
    required this.speed,
    required this.color,
  });

  Vector2 position;
  double pathLength;
  final String emoji;
  final double size;
  final double speed;
  final Color color;
}

class EmojiBubbles extends StatefulWidget {
  const EmojiBubbles({super.key});

  @override
  State<EmojiBubbles> createState() => _EmojiBubblesState();
}

class _EmojiBubblesState extends State<EmojiBubbles>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (1000 / 60).round()),
  )..addListener(_runLoop);

  DateTime? _lastUpdate;
  late final List<Bubble> _bubbles = [];
  late final List<Bubble> _bubblesToRemove = [];
  late final _random = math.Random();

  void _generateBubbles(bool happy) {
    final mediaQuery = MediaQuery.of(context);
    final homeBloc = context.read<HomeBloc>();
    final color = homeBloc.state.isSeeSourceAnswersVisible
        ? VertexColors.deepArctic
        : VertexColors.white;

    const cellebrateImages = [
      'assets/rating-assets/confetti.png',
      'assets/rating-assets/heart.png',
      'assets/rating-assets/star.png',
      'assets/rating-assets/thumbs-up.png',
    ];
    const beDepressedImages = [
      'assets/rating-assets/rain.png',
      'assets/rating-assets/sad.png',
      'assets/rating-assets/thumbs-down.png',
    ];

    final emojis = happy ? cellebrateImages : beDepressedImages;

    const numberOfBubbles = 15;

    final speedTween = Tween<double>(
      begin: 400,
      end: 1800,
    );

    final sizeTween = Tween<double>(
      begin: 60,
      end: 120,
    );

    for (var i = 0; i < numberOfBubbles; i++) {
      final emoji = emojis[_random.nextInt(emojis.length)];
      final size = sizeTween.transform(_random.nextDouble());
      final speed = speedTween.transform(_random.nextDouble());

      final pathLength = mediaQuery.size.height + size;
      _bubbles.add(
        Bubble(
          position: Vector2(
            _random.nextDouble() * mediaQuery.size.width,
            pathLength,
          ),
          pathLength: pathLength + size,
          emoji: emoji,
          size: size,
          speed: speed,
          color: color,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void _initAnimation(bool happy) {
    _generateBubbles(happy);
    _controller.repeat();
  }

  void _stopAnimation() {
    _controller.stop();
  }

  void _runLoop() {
    final now = DateTime.now();
    final dt = _lastUpdate == null
        ? 0.0
        : now.difference(_lastUpdate!).inMilliseconds / 1000;
    _lastUpdate = now;

    _update(dt);
    setState(() {});
  }

  double _interpolatePosition(Bubble buble, double dt) {
    // Speed decreases as the bubble goes up
    final speed = buble.speed *
        math.max(
          .4,
          buble.position.y / buble.pathLength,
        );
    return buble.position.y - speed * dt;
  }

  void _update(double dt) {
    for (final bubble in _bubbles) {
      bubble.position.y = _interpolatePosition(bubble, dt);

      if (bubble.position.y < -bubble.size) {
        _bubblesToRemove.add(bubble);
      }
    }

    _bubbles.removeWhere((bubble) => _bubblesToRemove.contains(bubble));

    if (_bubbles.isEmpty) {
      _stopAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        final last = state.answerFeedbacks.last;
        _initAnimation(last == AnswerFeedback.good);
      },
      listenWhen: (previous, current) =>
          previous.answerFeedbacks.length != current.answerFeedbacks.length,
      child: SizedBox.expand(
        child: Stack(
          children: [
            for (final bubble in _bubbles)
              Positioned(
                left: bubble.position.x,
                top: bubble.position.y,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: bubble.color,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: bubble.size,
                    height: bubble.size,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(bubble.size / 4),
                        child: Image.asset(
                          bubble.emoji,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
