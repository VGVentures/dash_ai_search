import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/transition_screen_mixin.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView>
    with SingleTickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcomeToAskQuestion];

  @override
  List<Status> get forwardExitStatuses => [Status.askQuestionToThinking];

  @override
  void initState() {
    forwardTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<HomeBloc>().add(const AskQuestion());
        }
      });

    super.initState();

    _opacity =
        Tween<double>(begin: 0, end: 1).animate(forwardTransitionController);
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
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.questionScreenTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 40),
            QuestionInputTextField(
              icon: vertexIcons.stars.image(),
              hint: l10n.questionHint,
              actionText: l10n.ask,
              onTextUpdated: (String query) {
                context.read<HomeBloc>().add(QueryUpdated(query: query));
              },
              onActionPressed: () {
                context.read<HomeBloc>().add(const QuestionAsked());
              },
            ),
//FromAskQuestionToResults
          ],
        ),
      ),
    );
  }
}
