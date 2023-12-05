import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_repository/questions_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(context.read<QuestionsRepository>()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  @visibleForTesting
  const HomeView({super.key});

  static const _dashRightKey = Key('dashAnimationContainer_right');
  static const _dashLeftKey = Key('dashAnimationContainer_left');

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;

    return Scaffold(
      backgroundColor: VertexColors.arctic,
      body: Stack(
        children: [
          if (state.isWelcomeVisible)
            const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Background(),
            ),
          if (state.isWelcomeVisible) const WelcomeView(),
          if (state.isQuestionVisible) const QuestionView(),
          if (state.isThinkingVisible) const ThinkingView(),
          if (state.isResultsVisible) const ResultsView(),
          Positioned(
            top: 40,
            left: 48,
            child: Logo(hasDarkBackground: state.isSeeSourceAnswersVisible),
          ),
          if (state.isDashOnRight)
            const Positioned(
              bottom: 50,
              right: 50,
              child: DashAnimationContainer(
                right: true,
                key: _dashRightKey,
              ),
            ),
          if (state.isDashOnLeft)
            const Positioned(
              bottom: 50,
              left: 50,
              child: DashAnimationContainer(
                right: false,
                key: _dashLeftKey,
              ),
            ),
        ],
      ),
    );
  }
}
