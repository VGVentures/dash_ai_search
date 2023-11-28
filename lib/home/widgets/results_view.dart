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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 64),
          const _SearchBox(),
          const SizedBox(height: 32),
          Stack(
            children: [
              Align(child: BlueContainer(summary: response.summary)),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
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
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: const SearchBox(),
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
  late Animation<Offset> _offset;
  late Animation<double> _rotation;
  late Animation<Size> _sizeAnimation;

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
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<HomeBloc>().add(const SeeSourceAnswers());
        }
      });
  }

  @override
  void initState() {
    super.initState();

    _offset =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );
    _rotation = Tween<double>(begin: 0.2, end: 0).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _sizeAnimation = Tween<Size>(
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

    final isSeeSourceAnswersVisible =
        context.select((HomeBloc bloc) => bloc.state.isSeeSourceAnswersVisible);

    return SlideTransition(
      position: _offset,
      child: RotationTransition(
        turns: _rotation,
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          builder: (context, child) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: VertexColors.googleBlue,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                constraints: BoxConstraints(
                  maxWidth: _sizeAnimation.value.width,
                  maxHeight: _sizeAnimation.value.height,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
                child: Stack(
                  children: [
                    if (isSeeSourceAnswersVisible) ...[
                      const Align(
                        alignment: Alignment.topLeft,
                        child: SeeSourceAnswersButton(),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.summary,
                        style: textTheme.headlineLarge
                            ?.copyWith(color: VertexColors.white, fontSize: 32),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: FeedbackButtons(),
                    ),
                    if (!isSeeSourceAnswersVisible)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: SeeSourceAnswersButton(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SeeSourceAnswersButton extends StatelessWidget {
  const SeeSourceAnswersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 64,
      child: TertiaryCTA(
        label: l10n.seeSourceAnswers,
        icon: vertexIcons.arrowForward.image(),
        onPressed: () =>
            context.read<HomeBloc>().add(const SeeSourceAnswersRequested()),
      ),
    );
  }
}
