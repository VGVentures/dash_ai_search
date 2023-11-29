import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phased/phased.dart';

class ThinkingView extends StatefulWidget {
  const ThinkingView({super.key});

  @override
  State<ThinkingView> createState() => ThinkingViewState();
}

class ThinkingViewState extends State<ThinkingView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.askQuestionToThinking];

  @override
  List<Status> get forwardExitStatuses => [Status.thinkingToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();
    _opacity =
        Tween<double>(begin: 0, end: 1).animate(enterTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const ThinkingAnimationView(),
    );
  }
}

enum ThinkingAnimationPhase {
  initial,
  thinkingIn,
  thinkingOut,
}

class ThinkingAnimationView extends StatefulWidget {
  const ThinkingAnimationView({
    super.key,
    @visibleForTesting this.animationState,
  });

  final PhasedState<ThinkingAnimationPhase>? animationState;

  @override
  State<ThinkingAnimationView> createState() => _ThinkingAnimationViewState();
}

class _ThinkingAnimationViewState extends State<ThinkingAnimationView> {
  late final _state = widget.animationState ??
      PhasedState<ThinkingAnimationPhase>(
        values: ThinkingAnimationPhase.values,
        initialValue: ThinkingAnimationPhase.initial,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == Status.thinkingToResults) {
          _state.value = ThinkingAnimationPhase.thinkingOut;
        }
      },
      child: ThinkingAnimation(
        state: _state,
      ),
    );
  }
}

class ThinkingAnimation extends Phased<ThinkingAnimationPhase> {
  const ThinkingAnimation({
    required super.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final query = context.select((HomeBloc bloc) => bloc.state.query);
    return Stack(
      children: [
        Align(
          child: CirclesAnimation(
            state: state,
          ),
        ),
        Align(
          child: TextArea(query: query, state: state),
        ),
      ],
    );
  }
}

class TextArea extends StatelessWidget {
  @visibleForTesting
  const TextArea({required this.query, required this.state, super.key});

  final String query;
  final PhasedState<ThinkingAnimationPhase> state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const slideDuration = Duration(milliseconds: 1200);
    const opacityDuration = Duration(milliseconds: 800);

    return AnimatedOpacity(
      duration: opacityDuration,
      opacity: state.phaseValue(
        values: {
          ThinkingAnimationPhase.thinkingOut: 0,
        },
        defaultValue: 1,
      ),
      child: AnimatedSlide(
        curve: Curves.decelerate,
        duration: slideDuration,
        offset: state.phaseValue(
          values: {
            ThinkingAnimationPhase.initial: const Offset(0, 1),
          },
          defaultValue: Offset.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.thinkingHeadline,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: VertexColors.flutterNavy),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: Text(
                query,
                textAlign: TextAlign.center,
                style: textTheme.displayLarge
                    ?.copyWith(color: VertexColors.flutterNavy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclesAnimation extends StatelessWidget {
  const CirclesAnimation({
    required this.state,
    super.key,
  });

  final PhasedState<ThinkingAnimationPhase> state;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.transparent;
    const borderColor = VertexColors.googleBlue;
    const opacityDuration = Duration(milliseconds: 800);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.maxHeight < constraints.maxWidth
            ? constraints.maxHeight
            : constraints.maxWidth;

        final bigCircleRadius = viewport / 2;
        final mediumCircleRadius = bigCircleRadius * .59;
        final smallCircleRadius = bigCircleRadius * .27;

        const scaleDuration = Duration(seconds: 2);

        return SizedBox(
          width: viewport,
          height: viewport,
          child: AnimatedOpacity(
            duration: opacityDuration,
            opacity: state.phaseValue(
              values: {
                ThinkingAnimationPhase.initial: .8,
                ThinkingAnimationPhase.thinkingOut: 0,
              },
              defaultValue: 1,
            ),
            child: AnimatedScale(
              duration: scaleDuration,
              curve: Curves.decelerate,
              scale: state.phaseValue(
                values: {
                  ThinkingAnimationPhase.initial: .6,
                  ThinkingAnimationPhase.thinkingOut: .6,
                },
                defaultValue: 1.05,
              ),
              child: Circle(
                dotted: true,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                radius: bigCircleRadius,
                child: Center(
                  child: Circle(
                    dotted: true,
                    backgroundColor: backgroundColor,
                    borderColor: borderColor,
                    radius: mediumCircleRadius,
                    child: Center(
                      child: Circle(
                        dotted: true,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor,
                        radius: smallCircleRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
