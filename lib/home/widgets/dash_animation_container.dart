import 'package:dash_ai_search/home/home.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phased/phased.dart';

class DashAnimationContainer extends StatefulWidget {
  const DashAnimationContainer({
    super.key,
    @visibleForTesting this.animationState,
  });

  final PhasedState<DashAnimationPhase>? animationState;

  @override
  State<DashAnimationContainer> createState() => _DashAnimationContainerState();
}

class _DashAnimationContainerState extends State<DashAnimationContainer> {
  late final _state = widget.animationState ??
      PhasedState<DashAnimationPhase>(
        values: DashAnimationPhase.values,
        initialValue: DashAnimationPhase.initial,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == Status.askQuestionToThinking ||
            state.status == Status.resultsToSourceAnswers) {
          _state.value = DashAnimationPhase.dashOut;
        } else if (state.status == Status.thinkingToResults) {
          _state.value = DashAnimationPhase.dashIn;
        }
      },
      child: DashAnimation(
        state: _state,
      ),
    );
  }
}

enum DashAnimationPhase {
  initial,
  dashIn,
  dashOut,
}

class DashAnimation extends Phased<DashAnimationPhase> {
  @visibleForTesting
  const DashAnimation({
    required super.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    const slideDuration = Duration(milliseconds: 1200);
    const rotationDuration = Duration(milliseconds: 1200);

    return AnimatedSlide(
      duration: slideDuration,
      curve: Curves.decelerate,
      offset: state.phaseValue(
        values: {
          DashAnimationPhase.initial: const Offset(-1.2, 0),
          DashAnimationPhase.dashOut: const Offset(-1.2, 0),
        },
        defaultValue: Offset.zero,
      ),
      child: AnimatedRotation(
        duration: rotationDuration,
        curve: Curves.decelerate,
        turns: state.phaseValue(
          values: {
            DashAnimationPhase.initial: -.08,
            DashAnimationPhase.dashOut: -.04,
          },
          defaultValue: 0,
        ),
        child: DashSpriteAnimation(
          height: screenSize.height / 3,
          width: screenSize.height / 3,
        ),
      ),
    );
  }
}

class DashSpriteAnimation extends StatefulWidget {
  const DashSpriteAnimation({
    required this.width,
    required this.height,
    @visibleForTesting this.images,
    super.key,
  });

  static const dashFrameSize = Size(1500, 1500);
  final Images? images;
  final double width;
  final double height;

  @override
  State<DashSpriteAnimation> createState() => DashSpriteAnimationState();
}

@visibleForTesting
class DashSpriteAnimationState extends State<DashSpriteAnimation> {
  var _waved = false;
  bool _loaded = false;
  SpriteAnimation? _reaction;

  late final images = widget.images ?? Images(prefix: 'assets/animations/');

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation waveAnimation;
  late final SpriteAnimation happyAnimation;
  late final SpriteAnimation sadAnimation;

  @override
  void initState() {
    super.initState();

    _loadAnimations();
  }

  Future<void> _loadAnimations() async {
    final [idle, wave, happy, sad] = await Future.wait([
      images.load('dash_idle_animation.png'),
      images.load('dash_wave_animation.png'),
      images.load('dash_happy_animation.png'),
      images.load('dash_sad_animation.png'),
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

    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: widget.width,
      width: widget.height,
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) =>
            previous.answerFeedback != current.answerFeedback,
        listener: (context, state) {
          if (state.answerFeedback == AnswerFeedback.good) {
            setState(() {
              _reaction = happyAnimation;
            });
          } else if (state.answerFeedback == AnswerFeedback.bad) {
            setState(() {
              _reaction = sadAnimation;
            });
          }
        },
        child: Builder(
          builder: (context) {
            if (!_waved) {
              return SpriteAnimationWidget(
                animation: waveAnimation,
                animationTicker: waveAnimation.createTicker(),
                onComplete: () {
                  setState(() {
                    _waved = true;
                  });
                },
              );
            }

            final currentReaction = _reaction;

            if (currentReaction != null) {
              return SpriteAnimationWidget(
                animation: currentReaction,
                animationTicker: currentReaction.createTicker(),
                onComplete: () {
                  setState(() {
                    _reaction = null;
                  });
                },
              );
            }

            return SpriteAnimationWidget(
              animation: idleAnimation,
              animationTicker: idleAnimation.createTicker(),
            );
          },
        ),
      ),
    );
  }
}
