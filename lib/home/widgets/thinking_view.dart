import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: const _ThinkingView(),
    );
  }
}

class _ThinkingView extends StatelessWidget {
  const _ThinkingView();

  @override
  Widget build(BuildContext context) {
    final query = context.select((HomeBloc bloc) => bloc.state.query);

    return Stack(
      children: [
        const Align(child: Circles()),
        Align(
          child: TextArea(query: query),
        ),
      ],
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
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 300),
          child: Text(
            query,
            textAlign: TextAlign.center,
            style: textTheme.displayLarge,
          ),
        ),
      ],
    );
  }
}

class Circles extends StatelessWidget {
  const Circles({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.transparent;
    const borderColor = VertexColors.googleBlue;
    return const Stack(
      children: [
        Circle(
          dotted: true,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          radius: 162,
        ),
        Circle(
          dotted: true,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          radius: 353,
        ),
        Circle(
          dotted: true,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          radius: 590,
        ),
      ],
    );
  }
}
