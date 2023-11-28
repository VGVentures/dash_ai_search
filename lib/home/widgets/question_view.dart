import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<QuestionView> createState() => QuestionViewState();
}

class QuestionViewState extends State<QuestionView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcomeToAskQuestion];

  @override
  List<Status> get forwardExitStatuses => [Status.askQuestionToThinking];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<HomeBloc>().add(const AskQuestion());
        }
      });
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
      child: const _QuestionView(),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.questionScreenTitle,
              textAlign: TextAlign.center,
              style: textTheme.displayLarge
                  ?.copyWith(color: VertexColors.flutterNavy),
            ),
            const SizedBox(height: 40),
            const SearchBox(),
          ],
        ),
      ),
    );
  }
}
