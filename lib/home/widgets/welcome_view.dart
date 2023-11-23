import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final state = context.watch<HomeBloc>().state;
    final isAnimating = state.status == Status.welcomeToAskQuestion;

    return AnimatedOpacity(
      opacity: isAnimating ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: IgnorePointer(
        ignoring: !state.isWelcomeVisible,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.initialScreenTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: VertexColors.navy,
                  ),
                ),
                const SizedBox(height: 40),
                CTAButton(
                  icon: vertexIcons.arrowForward.image(),
                  label: l10n.startAsking,
                  onPressed: () => context
                      .read<HomeBloc>()
                      .add(const FromWelcomeToQuestion()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
