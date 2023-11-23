import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThinkingView extends StatelessWidget {
  const ThinkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final state = context.watch<HomeBloc>().state;
    final isAnimating = state.status == Status.askQuestionToThinking;
    final query = context.select((HomeBloc bloc) => bloc.state.query);
    return AnimatedOpacity(
      opacity: isAnimating ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Center(
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
      ),
    );
  }
}
