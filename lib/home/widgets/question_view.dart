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
              const QuestionInputTextField(),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionInputTextField extends StatefulWidget {
  const QuestionInputTextField({super.key});

  @override
  State<QuestionInputTextField> createState() => _QuestionTextFieldState();
}

class _QuestionTextFieldState extends State<QuestionInputTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      constraints: const BoxConstraints(maxWidth: 659),
      child: TextField(
        controller: _controller,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: VertexColors.navy,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: vertexIcons.stars.image(),
          ),
          hintText: 'Ex: How do I manage a state?',
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CTAButton(
              label: l10n.ask,
            ),
          ),
        ),
      ),
    );
  }
}
