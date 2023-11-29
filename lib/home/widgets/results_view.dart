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
    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 64),
          const SearchBox(),
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

class BlueContainer extends StatelessWidget {
  @visibleForTesting
  const BlueContainer({required this.summary, super.key});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: VertexColors.googleBlue,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              summary,
              style: textTheme.headlineLarge
                  ?.copyWith(color: VertexColors.white, fontSize: 32),
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: FeedbackButtons(),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: SeeSourceAnswersButton(),
          ),
        ],
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
