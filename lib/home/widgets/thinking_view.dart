import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/transition_screen_mixin.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThinkingView extends StatefulWidget {
  const ThinkingView({super.key});

  @override
  State<ThinkingView> createState() => _ThinkingViewState();
}

class _ThinkingViewState extends State<ThinkingView>
    with SingleTickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.askQuestionToThinking];

  @override
  List<Status> get forwardExitStatuses => [Status.thinkingToResults];

  @override
  void initState() {
    forwardTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    super.initState();

    _opacity =
        Tween<double>(begin: 0, end: 1).animate(forwardTransitionController);
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
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final query = context.select((HomeBloc bloc) => bloc.state.query);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.thinkingHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              query,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge,
            ),
          ],
        ),
      ),
    );
  }
}
