import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
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
        if (state.status == Status.askQuestionToThinking) {
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
    super.key,
  });

  static const dashSize = Size(800, 800);
  static const dashIdleSize = Size(1500, 1500);
  final double width;
  final double height;

  @override
  State<DashSpriteAnimation> createState() => _DashSpriteAnimationState();
}

class _DashSpriteAnimationState extends State<DashSpriteAnimation> {
  var _waved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.width,
      width: widget.height,
      child: _waved
          ? const AnimatedSprite(
              showLoadingIndicator: false,
              sprites: Sprites(
                asset: 'dash_idle_animation.png',
                size: DashSpriteAnimation.dashIdleSize,
                frames: 12,
                stepTime: 0.07,
              ),
            )
          : AnimatedSprite(
              showLoadingIndicator: false,
              sprites: const Sprites(
                asset: 'dash_animation.png',
                size: DashSpriteAnimation.dashSize,
                frames: 34,
                stepTime: 0.07,
              ),
              mode: AnimationMode.oneTime,
              onComplete: () {
                setState(() {
                  _waved = true;
                });
              },
            ),
    );
  }
}
