import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({super.key});

  @override
  State<ResultsView> createState() => ResultsViewState();
}

class ResultsViewState extends State<ResultsView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;
  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  List<Status> get forwardExitStatuses => [Status.results];

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
      child: const _ResultsView(),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        BlueContainer(),
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          child: Align(
            child: SearchBoxView(),
          ),
        ),
      ],
    );
  }
}

class SearchBoxView extends StatefulWidget {
  @visibleForTesting
  const SearchBoxView({super.key});

  @override
  State<SearchBoxView> createState() => SearchBoxViewState();
}

class SearchBoxViewState extends State<SearchBoxView>
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
  const BlueContainer({super.key});

  @override
  State<BlueContainer> createState() => BlueContainerState();
}

class BlueContainerState extends State<BlueContainer>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offsetEnterIn;
  late Animation<double> _rotationEnterIn;
  late Animation<RelativeRect> _positionExitOut;
  late Animation<double> _borderRadiusExitOut;
  late Animation<Size> _sizeIn;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

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
          context.read<HomeBloc>().add(const SeeResultsSourceAnswers());
        }
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
    return PositionedTransition(
      rect: _positionExitOut,
      child: Align(
        child: SlideTransition(
          position: _offsetEnterIn,
          child: RotationTransition(
            turns: _rotationEnterIn,
            child: AnimatedBuilder(
              animation: _sizeIn,
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
                    child: const _AiResponse(),
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

class _AiResponse extends StatefulWidget {
  const _AiResponse();

  @override
  State<_AiResponse> createState() => _AiResponseState();
}

class _AiResponseState extends State<_AiResponse>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _leftPaddingExitOut;
  late Animation<double> _rightPaddingExitOut;
  late Animation<double> _topPaddingExitOut;
  late Animation<double> _bottomPaddingExitOut;

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

    _leftPaddingExitOut = Tween<double>(begin: 48, end: 165).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _rightPaddingExitOut = Tween<double>(begin: 0, end: 150).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _topPaddingExitOut = Tween<double>(begin: 0, end: 155).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _bottomPaddingExitOut = Tween<double>(begin: 172, end: 40).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final state = context.watch<HomeBloc>().state;

    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);

    return AnimatedBuilder(
      animation: _leftPaddingExitOut,
      builder: (context, child) => Padding(
        padding: EdgeInsets.fromLTRB(_leftPaddingExitOut.value, 64, 48, 64),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _topPaddingExitOut,
                    builder: (context, child) =>
                        SizedBox(height: _topPaddingExitOut.value),
                  ),
                  SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: exitTransitionController,
                      curve: Curves.decelerate,
                    ),
                    child: const BackToAnswerButton(),
                  ),
                  Flexible(
                    child: Expanded(
                      child: Text(
                        response.summary,
                        style: textTheme.headlineLarge?.copyWith(
                          color: VertexColors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _bottomPaddingExitOut,
                    builder: (context, child) =>
                        SizedBox(height: _bottomPaddingExitOut.value),
                  ),
                  const Row(
                    children: [
                      Expanded(child: FeedbackButtons()),
                      Expanded(child: SeeSourceAnswersButton()),
                    ],
                  ),
                ],
              ),
            ),
            if (state.isSeeSourceAnswersVisible) ...[
              AnimatedBuilder(
                animation: _bottomPaddingExitOut,
                builder: (context, child) =>
                    SizedBox(width: _rightPaddingExitOut.value),
              ),
              CarouselView(documents: response.documents),
            ],
          ],
        ),
      ),
    );
  }
}

class CarouselView extends StatefulWidget {
  @visibleForTesting
  const CarouselView({
    required this.documents,
    super.key,
  });

  final List<VertexDocument> documents;

  @override
  State<CarouselView> createState() => CarouselViewState();
}

class CarouselViewState extends State<CarouselView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offsetEnterIn;
  late Animation<double> _rotationEnterIn;

  @override
  List<Status> get forwardEnterStatuses => [Status.resultsToSourceAnswers];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
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
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetEnterIn,
      child: RotationTransition(
        turns: _rotationEnterIn,
        child: Expanded(
          child: SourcesCarouselView(
            documents: widget.documents,
          ),
        ),
      ),
    );
  }
}

class BackToAnswerButton extends StatefulWidget {
  @visibleForTesting
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
          ),
        ),
      ),
    );
  }
}

class SeeSourceAnswersButton extends StatefulWidget {
  @visibleForTesting
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
