import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/question/question.dart';
import 'package:dash_ai_search/results/results.dart';
import 'package:dash_ai_search/thinking/thinking.dart';
import 'package:dash_ai_search/welcome/welcome.dart';
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
    const response = VertexResponse(
      summary: 'Flutter is a free and open source software development '
          "kit (SDK) from Google [1]. It's used to create beautiful, "
          'fast user experiences, ,,,for mobile, web, and desktop '
          'applications [1]. Flutter works with existing code and is used '
          'by developers and organizations around the world [1]. [3]. '
          'Flutter is a fully open source project [3].',
      documents: [
        VertexDocument(
          id: '1',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '2',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '3',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '4',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
      ],
    );

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
      'renders DashAnimationContainer on the left if dash is visible',
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
      'renders DashAnimationContainer on the right if dash is visible',
      (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            status: Status.seeSourceAnswers,
            vertexResponse: response,
          ),
        );
        await tester.pumpApp(
          RepositoryProvider.value(
            value: dashAnimations,
            child: BlocProvider.value(
              value: homeBloc,
              child: HomeView(),
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
