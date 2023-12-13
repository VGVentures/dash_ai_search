import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phased/phased.dart';

class DashAnimationContainer extends StatefulWidget {
  const DashAnimationContainer({
    required this.right,
    @visibleForTesting this.animationState,
    super.key,
  });

  final bool right;

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
        if (widget.right) {
          if (state.status == Status.sourceAnswersBackToResults) {
            _state.value = DashAnimationPhase.dashOut;
          } else if (state.status == Status.resultsToSourceAnswers) {
            _state.value = DashAnimationPhase.dashIn;
          }
        } else {
          if (state.status == Status.resultsToSourceAnswers) {
            _state.value = DashAnimationPhase.dashOut;
          } else if (state.status == Status.sourceAnswersBackToResults) {
            _state.value = DashAnimationPhase.dashIn;
          }
        }
      },
      child: DashAnimation(
        state: _state,
        slideOffset: widget.right ? 1.2 : -1.2,
        rotation: widget.right ? .08 : -.08,
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
    required this.slideOffset,
    required this.rotation,
    super.key,
  });

  final double slideOffset;
  final double rotation;

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
          DashAnimationPhase.initial: Offset(slideOffset, 0),
          DashAnimationPhase.dashOut: Offset(slideOffset, 0),
        },
        defaultValue: Offset.zero,
      ),
      child: AnimatedRotation(
        duration: rotationDuration,
        curve: Curves.decelerate,
        turns: state.phaseValue(
          values: {
            DashAnimationPhase.initial: rotation,
            DashAnimationPhase.dashOut: rotation / 2,
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
    super.key,
  });

  static const dashFrameSize = Size(1500, 1500);
  final double width;
  final double height;

  @override
  State<DashSpriteAnimation> createState() => DashSpriteAnimationState();
}

@visibleForTesting
class DashSpriteAnimationState extends State<DashSpriteAnimation> {
  var _waved = false;
  SpriteAnimation? _reaction;

  late final SpriteAnimationTicker _waveTicker;
  @visibleForTesting
  late SpriteAnimationTicker thinkingTicker;

  @override
  void initState() {
    super.initState();
    final animations = context.read<DashAnimations>();
    _waveTicker = animations.waveAnimation.createTicker();
    thinkingTicker = animations.thinkingAnimation.createTicker();
  }

  @override
  Widget build(BuildContext context) {
    final animations = context.read<DashAnimations>();
    return SizedBox(
      height: widget.width,
      width: widget.height,
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.answerFeedbacks != current.answerFeedbacks,
            listener: (context, state) {
              // Only play if we are not playing any other animation
              // and if there is a feedback to play.
              if (_reaction == null && state.answerFeedbacks.isNotEmpty) {
                final lastFeedback = state.answerFeedbacks.last;
                if (lastFeedback == AnswerFeedback.good) {
                  setState(() {
                    _reaction = animations.happyAnimation;
                  });
                } else if (lastFeedback == AnswerFeedback.bad) {
                  setState(() {
                    _reaction = animations.sadAnimation;
                  });
                }
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                (current.status.isThinking),
            listener: (context, state) {
              thinkingTicker = animations.thinkingAnimation.createTicker();
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == Status.thinkingToResults,
            listener: (context, state) {
              setState(() {
                _reaction = animations.thinkingAnimation.reversed();
              });
            },
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (!_waved) {
              return SpriteAnimationWidget(
                animation: animations.waveAnimation,
                animationTicker: _waveTicker,
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

            final idleAnimation = state.status.isThinking
                ? animations.thinkingAnimation
                : animations.idleAnimation;

            final idleTicker = state.status.isThinking
                ? thinkingTicker
                : idleAnimation.createTicker();

            return SpriteAnimationWidget(
              animation: idleAnimation,
              animationTicker: idleTicker,
            );
          },
        ),
      ),
    );
  }
}
