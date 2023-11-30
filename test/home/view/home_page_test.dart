import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

class _MockQuestionsRepository extends Mock implements QuestionsRepository {}

void main() {
  group('HomePage', () {
    late QuestionsRepository questionsRepository;
    late DashAnimations dashAnimations;

    setUpAll(() async {
      dashAnimations = DashAnimations();
      await dashAnimations.load();
    });

    setUp(() {
      questionsRepository = _MockQuestionsRepository();
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        RepositoryProvider.value(
          value: dashAnimations,
          child: RepositoryProvider.value(
            value: questionsRepository,
            child: HomePage(),
          ),
        ),
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeBloc homeBloc;
    late DashAnimations dashAnimations;

    setUpAll(() async {
      dashAnimations = DashAnimations();
      await dashAnimations.load();
    });

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    Widget bootstrap() => RepositoryProvider.value(
          value: dashAnimations,
          child: BlocProvider.value(
            value: homeBloc,
            child: HomeView(),
          ),
        );

    testWidgets('renders WelcomeView if isWelcomeVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(HomeState());
      await tester.pumpApp(bootstrap());

      expect(find.byType(WelcomeView), findsOneWidget);
    });

    testWidgets('renders QuestionView if isQuestionVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          status: Status.askQuestion,
        ),
      );
      await tester.pumpApp(bootstrap());

      expect(find.byType(QuestionView), findsOneWidget);
    });

    testWidgets('renders ThinkingView if isThinkingVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          status: Status.thinking,
        ),
      );
      await tester.pumpApp(bootstrap());

      expect(find.byType(ThinkingView), findsOneWidget);
    });

    testWidgets('renders ResultsView if isResultsVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          status: Status.results,
        ),
      );
      await tester.pumpApp(bootstrap());

      expect(find.byType(ResultsView), findsOneWidget);
    });

    testWidgets(
      'renders DashAnimationContainer on the left if dash is '
      'visible and is not sources',
      (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            status: Status.results,
          ),
        );
        await tester.pumpApp(bootstrap());

        final widget = tester.widget<DashAnimationContainer>(
          find.byType(DashAnimationContainer),
        );

        expect(widget.right, isFalse);
      },
    );

    testWidgets(
      'renders DashAnimationContainer on the left if dash is '
      'visible and is not sources',
      (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            status: Status.results,
          ),
        );
        await tester.pumpApp(
          RepositoryProvider.value(
            value: dashAnimations,
            child: BlocProvider.value(
              value: homeBloc,
              child: HomeView(dashOnRightStatus: Status.results),
            ),
          ),
        );

        final widget = tester.widget<DashAnimationContainer>(
          find.byType(DashAnimationContainer),
        );

        expect(widget.right, isTrue);
      },
    );
  });
}
