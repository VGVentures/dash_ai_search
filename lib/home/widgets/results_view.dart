import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/transition_screen_mixin.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);
    return Stack(
      children: [
        BlueContainer(summary: response.summary),
        const Positioned(
          top: 90,
          left: 0,
          right: 0,
          child: Align(
            child: _SearchBox(),
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatefulWidget {
  const _SearchBox();

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offset;
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();

    _offset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(enterTransitionController);
    _opacity =
        Tween<double>(begin: 0, end: 1).animate(enterTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 595,
      ),
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _opacity,
          child: const SearchBox(),
        ),
      ),
    );
  }
}

class BlueContainer extends StatefulWidget {
  @visibleForTesting
  const BlueContainer({required this.summary, super.key});

  final String summary;

  @override
  State<BlueContainer> createState() => _BlueContainerState();
}

class _BlueContainerState extends State<BlueContainer>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offsetEnterIn;
  late Animation<double> _rotationEnterIn;
  late Animation<RelativeRect> _positionExitOut;
  late Animation<double> _sizeExitIn;
  late Animation<double> _borderRadiusExitOut;
  late Animation<Size> _sizeIn;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<HomeBloc>().add(const Results());
        }
      });

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        final state = context.read<HomeBloc>().state;

        if (status == AnimationStatus.completed &&
            state.status == Status.resultsToSourceAnswers) {
          context.read<HomeBloc>().add(const SeeSourceAnswers());
        }
        /*
        if (status == AnimationStatus.completed &&
            state.status == Status.sourceAnswersBackToResults) {
          context.read<HomeBloc>().add(const Results());
        }
        */
      });
  }

  @override
  void initState() {
    super.initState();

    _offsetEnterIn =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );
    _rotationEnterIn = Tween<double>(begin: 0.2, end: 0).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _sizeExitIn = CurvedAnimation(
      parent: exitTransitionController,
      curve: Curves.decelerate,
    );

    _positionExitOut = RelativeRectTween(
      begin: const RelativeRect.fromLTRB(0, 230, 0, 0),
      end: RelativeRect.fill,
    ).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _borderRadiusExitOut = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _sizeIn = Tween<Size>(
      begin: const Size(600, 700),
      end: Size.infinite,
    ).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PositionedTransition(
      rect: _positionExitOut,
      child: Align(
        child: SlideTransition(
          position: _offsetEnterIn,
          child: RotationTransition(
            turns: _rotationEnterIn,
            child: AnimatedBuilder(
              animation: _sizeExitIn,
              builder: (context, child) {
                return Center(
                  child: Container(
                    width: _sizeIn.value.width,
                    height: _sizeIn.value.height,
                    decoration: BoxDecoration(
                      color: VertexColors.googleBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(_borderRadiusExitOut.value),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 64,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            widget.summary,
                            style: textTheme.headlineLarge?.copyWith(
                              color: VertexColors.white,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        const BackToAnswerButton(),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: FeedbackButtons(),
                        ),
                        const SeeSourceAnswersButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BackToAnswerButton extends StatefulWidget {
  const BackToAnswerButton({super.key});

  @override
  State<BackToAnswerButton> createState() => _BackToAnswerButtonState();
}

class _BackToAnswerButtonState extends State<BackToAnswerButton>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _sizeExitIn;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();

    _sizeExitIn = CurvedAnimation(
      parent: exitTransitionController,
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizeTransition(
      sizeFactor: _sizeExitIn,
      axis: Axis.horizontal,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 64,
          child: TertiaryCTA(
            label: l10n.backToAIAnswer,
            icon: vertexIcons.arrowBack.image(color: VertexColors.white),
            /*onPressed: () =>
            context.read<HomeBloc>().add(const BackToAnswerRequested()),*/
          ),
        ),
      ),
    );
  }
}

class SeeSourceAnswersButton extends StatefulWidget {
  const SeeSourceAnswersButton({super.key});

  @override
  State<SeeSourceAnswersButton> createState() => _SeeSourceAnswersButtonState();
}

class _SeeSourceAnswersButtonState extends State<SeeSourceAnswersButton>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacityExitOut;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();
    _opacityExitOut =
        Tween<double>(begin: 1, end: 0).animate(exitTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FadeTransition(
      opacity: _opacityExitOut,
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: 64,
          child: TertiaryCTA(
            label: l10n.seeSourceAnswers,
            icon: vertexIcons.arrowForward.image(),
            onPressed: () =>
                context.read<HomeBloc>().add(const SeeSourceAnswersRequested()),
          ),
        ),
      ),
    );
  }
}
