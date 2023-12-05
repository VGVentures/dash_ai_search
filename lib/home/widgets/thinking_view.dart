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
  late Animation<double> _opacityIn;
  late Animation<double> _opacityOut;
  late Animation<Offset> _offsetVerticalIn;
  late Animation<Offset> _offsetVerticalOut;

  @override
  List<Status> get forwardEnterStatuses =>
      [Status.askQuestionToThinking, Status.resultsToThinking];

  @override
  List<Status> get forwardExitStatuses => [Status.thinkingToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void initState() {
    super.initState();
    _opacityIn =
        Tween<double>(begin: 0, end: 1).animate(enterTransitionController);

    _opacityOut =
        Tween<double>(begin: 1, end: 0).animate(exitTransitionController);

    _offsetVerticalIn =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _offsetVerticalOut =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = context.select((HomeBloc bloc) => bloc.state.query);

    return Stack(
      children: [
        FadeTransition(
          opacity: _opacityIn,
          child: FadeTransition(
            opacity: _opacityOut,
            child: const ThinkingAnimationView(),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: SlideTransition(
                  position: _offsetVerticalIn,
                  child: SlideTransition(
                    position: _offsetVerticalOut,
                    child: TextArea(query: query),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Align(
      child: CirclesAnimation(
        state: state,
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  @visibleForTesting
  const TextArea({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.thinkingHeadline,
          textAlign: TextAlign.center,
          style:
              textTheme.bodyMedium?.copyWith(color: VertexColors.flutterNavy),
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
