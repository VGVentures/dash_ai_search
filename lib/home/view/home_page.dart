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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: VertexColors.arctic,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: Background(),
          ),
          Positioned(
            top: 40,
            left: 48,
            child: Logo(),
          ),
          _WelcomeView(),
          _QuestionView(),
          _ThinkingView(),
          _ResultsView(),
          Positioned(
            bottom: 50,
            left: 50,
            child: DashAnimation(),
          ),
        ],
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) => state.isWelcomeVisible,
      builder: (_, isVisible) =>
          isVisible ? const WelcomeView() : const SizedBox.shrink(),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) => state.isQuestionVisible,
      builder: (_, isVisible) =>
          isVisible ? const QuestionView() : const SizedBox.shrink(),
    );
  }
}

class _ThinkingView extends StatelessWidget {
  const _ThinkingView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) => state.isThinkingVisible,
      builder: (_, isVisible) =>
          isVisible ? const ThinkingView() : const SizedBox.shrink(),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) => state.isResultsVisible,
      builder: (_, isVisible) =>
          isVisible ? const ResultsView() : const SizedBox.shrink(),
    );
  }
}

class DashAnimation extends StatelessWidget {
  @visibleForTesting
  const DashAnimation({super.key});

  static const dashSize = Size(800, 800);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Container(
      alignment: Alignment.center,
      height: screenSize.height / 3,
      width: screenSize.height / 3,
      child: const AnimatedSprite(
        showLoadingIndicator: false,
        sprites: Sprites(
          asset: 'dash_animation.png',
          size: dashSize,
          frames: 34,
          stepTime: 0.07,
        ),
      ),
    );
  }
}
