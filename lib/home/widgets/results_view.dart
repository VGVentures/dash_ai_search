import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ResultsAnimationPhase {
  initial,
  results,
  resultsSourceAnswers,
}

const _searchBarTopPadding = 90.0;
const _questionBoxHeight = 84.0;

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
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            BlueContainer(constraints: constraints),
            const Positioned(
              top: _searchBarTopPadding,
              left: 0,
              right: 0,
              child: Align(
                child: SearchBoxView(),
              ),
            ),
          ],
        );
      },
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

    exitTransitionController = AnimationController(
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
        maxWidth: 659,
      ),
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _opacity,
          child: const SearchBox(
            askAgain: true,
          ),
        ),
      ),
    );
  }
}

class BlueContainer extends StatefulWidget {
  @visibleForTesting
  const BlueContainer({
    required this.constraints,
    super.key,
  });

  final BoxConstraints constraints;

  @override
  State<BlueContainer> createState() => BlueContainerState();
}

class BlueContainerState extends State<BlueContainer>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offsetEnterIn;
  late Animation<double> _rotationEnterIn;
  late Animation<RelativeRect> _positionExitOut;
  late Animation<double> _borderRadiusExitOut;
  @visibleForTesting
  late Animation<Size> sizeIn;

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
      duration: const Duration(milliseconds: 800),
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
        parent: exitTransitionController,
        curve: Curves.easeInExpo,
      ),
    );

    _initSizeIn();
  }

  @override
  void didUpdateWidget(covariant BlueContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initSizeIn();
  }

  void _initSizeIn() {
    sizeIn = Tween<Size>(
      begin: const Size(659, 732),
      end: Size(
        widget.constraints.maxWidth,
        widget.constraints.maxHeight,
      ),
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
              animation: sizeIn,
              builder: (context, child) {
                return Container(
                  width: sizeIn.value.width,
                  height: sizeIn.value.height,
                  decoration: BoxDecoration(
                    color: VertexColors.googleBlue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(_borderRadiusExitOut.value),
                    ),
                  ),
                  child: const _AiResponse(),
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
  late Animation<double> _topPaddingExitOut;

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
      duration: const Duration(milliseconds: 800),
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

    _topPaddingExitOut = Tween<double>(
      begin: 64,
      end: _questionBoxHeight + _searchBarTopPadding + 32,
    ).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;

    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);

    return AnimatedBuilder(
      animation: _leftPaddingExitOut,
      builder: (context, child) => Padding(
        padding: EdgeInsets.fromLTRB(
          _leftPaddingExitOut.value,
          _topPaddingExitOut.value,
          48,
          64,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizeTransition(
                    sizeFactor: CurvedAnimation(
                      parent: exitTransitionController,
                      curve: Curves.decelerate,
                    ),
                    child: const BackToAnswerButton(),
                  ),
                  if (state.status == Status.results ||
                      state.status == Status.thinkingToResults ||
                      state.status == Status.sourceAnswersBackToResults)
                    const Expanded(child: SummaryView())
                  else
                    const SummaryView(),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: 563,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FeedbackButtons(
                            onLike: () {
                              context.read<HomeBloc>().add(
                                    const AddAnswerFeedback(
                                      AnswerFeedback.good,
                                    ),
                                  );
                            },
                            onDislike: () {
                              context.read<HomeBloc>().add(
                                    const AddAnswerFeedback(
                                      AnswerFeedback.bad,
                                    ),
                                  );
                            },
                          ),
                          if (!state.isSeeSourceAnswersVisible)
                            const SeeSourceAnswersButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.isSeeSourceAnswersVisible) ...[
              Expanded(
                child: CarouselView(documents: response.documents),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SummaryView extends StatefulWidget {
  const SummaryView({
    super.key,
  });

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _width;

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

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

    _width = Tween<double>(begin: 563, end: 659).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parsed = context.select((HomeBloc bloc) => bloc.state.parsedSummary);

    return AnimatedBuilder(
      animation: _width,
      builder: (context, child) {
        return SizedBox(
          width: _width.value,
          child: RichText(
            text: TextSpan(
              children: [
                for (final element in parsed.elements)
                  if (element.isLink)
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          final isOnSeeSourceAnswers =
                              context.read<HomeBloc>().state.status ==
                                  Status.seeSourceAnswers;
                          if (isOnSeeSourceAnswers) {
                            context.read<HomeBloc>().add(
                                  NavigateSourceAnswers(
                                    element.text,
                                  ),
                                );
                          } else {
                            context.read<HomeBloc>().add(
                                  SeeSourceAnswersRequested(
                                    element.text,
                                  ),
                                );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: VertexColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Text(
                            element.text,
                            style: textTheme.labelLarge?.copyWith(
                              color: VertexColors.googleBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    TextSpan(
                      text: element.text,
                      style: textTheme.headlineLarge?.copyWith(
                        color: VertexColors.white,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
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

    exitTransitionController = AnimationController(
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
    final index = context.read<HomeBloc>().state.selectedIndex;
    return SlideTransition(
      position: _offsetEnterIn,
      child: RotationTransition(
        turns: _rotationEnterIn,
        child: SourcesCarouselView(
          documents: widget.documents,
          previouslySelectedIndex: index,
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
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

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
        child: TertiaryCTA(
          key: const Key('backToAnswerButtonKey'),
          label: l10n.backToAIAnswer,
          icon: vertexIcons.arrowBack.image(color: VertexColors.white),
          onPressed: () {
            context.read<HomeBloc>().add(const BackToAiSummaryTapped());
          },
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
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

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
        child: TertiaryCTA(
          label: l10n.seeSourceAnswers,
          icon: vertexIcons.arrowForward.image(
            color: VertexColors.white,
          ),
          onPressed: () => context
              .read<HomeBloc>()
              .add(const SeeSourceAnswersRequested(null)),
        ),
      ),
    );
  }
}
