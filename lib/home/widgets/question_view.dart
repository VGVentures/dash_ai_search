import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final state = context.watch<HomeBloc>().state;
    final isAnimating = state.status == Status.welcomeToAskQuestion;

    return AnimatedOpacity(
      opacity: isAnimating ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Center(
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
                hint: 'Ex: How do I manage a state?',
                action: CTAButton(
                  label: l10n.ask,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
