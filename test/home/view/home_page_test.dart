import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
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

    setUp(() {
      questionsRepository = _MockQuestionsRepository();
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        RepositoryProvider.value(
          value: questionsRepository,
          child: HomePage(),
        ),
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets('renders WelcomeView if isWelcomeVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(HomeState());
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: HomeView(),
        ),
      );

      expect(find.byType(WelcomeView), findsOneWidget);
    });

    testWidgets('renders QuestionView if isQuestionVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          status: Status.askQuestion,
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: HomeView(),
        ),
      );

      expect(find.byType(QuestionView), findsOneWidget);
    });

    testWidgets('renders ThinkingView if isThinkingVisible', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          status: Status.thinking,
        ),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: HomeView(),
        ),
      );

      expect(find.byType(ThinkingView), findsOneWidget);
    });

    group('ResultsView', () {
      testWidgets('is rendered if isResultsVisible', (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            status: Status.results,
          ),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: HomeView(),
          ),
        );

        expect(find.byType(ResultsView), findsOneWidget);
      });

      testWidgets('adds SeeSourceAnswersRequested to bloc', (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(status: Status.results),
        );
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: HomeView(),
          ),
        );
        expect(find.byType(SeeSourceAnswersButton), findsOneWidget);
        await tester.tap(find.byType(SeeSourceAnswersButton));
        verify(() => homeBloc.add(const SeeSourceAnswersRequested())).called(1);
      });
    });

    testWidgets('renders SeeSourceAnswers if isSeeSourceAnswersVisible',
        (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(status: Status.seeSourceAnswers),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: HomeView(),
        ),
      );

      expect(find.byType(SeeSourceAnswers), findsOneWidget);
    });
  });
}
