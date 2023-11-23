import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThinkingView extends StatelessWidget {
  const ThinkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isAnimating = context.select(
      (HomeBloc bloc) => bloc.state.status == Status.askQuestionToThinking,
    );
    final query = context.select((HomeBloc bloc) => bloc.state.query);
    return AnimatedOpacity(
      opacity: isAnimating ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Stack(
        children: [
          const Align(child: Circles()),
          Align(
            child: TextArea(query: query),
          ),
        ],
      ),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.thinkingHeadline,
          textAlign: TextAlign.center,
          style:
              VertexTextStyles.body.copyWith(color: VertexColors.flutterNavy),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 300),
          child: Text(
            query,
            textAlign: TextAlign.center,
            style: VertexTextStyles.display,
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
