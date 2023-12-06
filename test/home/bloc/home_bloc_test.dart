import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';

class _MockQuestionsRepository extends Mock implements QuestionsRepository {}

void main() {
  group('HomeBloc', () {
    late QuestionsRepository questionsRepository;

    setUp(() {
      questionsRepository = _MockQuestionsRepository();
    });

    HomeBloc buildBloc() {
      return HomeBloc(questionsRepository);
    }

    group('QueryUpdated', () {
      blocTest<HomeBloc, HomeState>(
        'emits query updated',
        build: buildBloc,
        act: (bloc) => bloc.add(QueryUpdated(query: 'new query')),
        expect: () => [
          HomeState(query: 'new query'),
        ],
      );
    });

    group('HomeQuestionAsked', () {
      blocTest<HomeBloc, HomeState>(
        'emits [Status.askQuestionToThinking, Status.thinkingToResults] '
        'with vertex response from _questionsRepository.getVertexResponse',
        setUp: () {
          when(() => questionsRepository.getVertexResponse(any()))
              .thenAnswer((_) async => VertexResponse.empty());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(HomeQuestionAsked('query')),
        expect: () => [
          HomeState(
            status: Status.askQuestionToThinking,
            submittedQuery: 'query',
          ),
          HomeState(
            status: Status.thinkingToResults,
            vertexResponse: VertexResponse.empty(),
            submittedQuery: 'query',
          ),
        ],
      );
    });

    group('HomeNavigated', () {
      blocTest<HomeBloc, HomeState>(
        'emits the new status',
        build: buildBloc,
        act: (bloc) => bloc.add(HomeNavigated(Status.askQuestion)),
        expect: () => [
          HomeState(status: Status.askQuestion),
        ],
      );
    });

    group('HomeQuestionAskedAgain', () {
      blocTest<HomeBloc, HomeState>(
        'emits [Status.resultsToThinking, Status.thinkingToResults] '
        'with vertex response from _questionsRepository.getVertexResponse',
        setUp: () {
          when(() => questionsRepository.getVertexResponse(any()))
              .thenAnswer((_) async => VertexResponse.empty());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(HomeQuestionAskedAgain('query')),
        expect: () => [
          HomeState(
            status: Status.resultsToThinking,
            submittedQuery: 'query',
          ),
          HomeState(
            status: Status.thinkingToResults,
            vertexResponse: VertexResponse.empty(),
            submittedQuery: 'query',
          ),
        ],
      );
    });

    group('HomeSeeSourceAnswersRequested', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.resultsToSourceAnswers',
        build: buildBloc,
        act: (bloc) => bloc.add(HomeSeeSourceAnswersRequested('[1]')),
        expect: () => [
          HomeState(status: Status.resultsToSourceAnswers),
        ],
      );
    });

    group('BackToAiResultsTapped', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.sourceAnswersBackToResults',
        build: buildBloc,
        act: (bloc) => bloc.add(HomeBackToAiSummaryTapped()),
        expect: () => [
          HomeState(status: Status.sourceAnswersBackToResults),
        ],
      );
    });

    group('HomeAnswerFeedbackAdded', () {
      blocTest<HomeBloc, HomeState>(
        'emits the new feedback',
        build: buildBloc,
        act: (bloc) => bloc.add(HomeAnswerFeedbackAdded(AnswerFeedback.good)),
        expect: () => [
          HomeState(
            answerFeedbacks: const [AnswerFeedback.good],
          ),
        ],
      );
    });

    group('HomeSourceAnswersNavigated', () {
      blocTest<HomeBloc, HomeState>(
        'emits updated selectedIndex',
        build: buildBloc,
        act: (bloc) => bloc.add(HomeSourceAnswersNavigated('[2]')),
        expect: () => [
          HomeState(
            selectedIndex: 1,
          ),
        ],
      );
    });
  });
}
