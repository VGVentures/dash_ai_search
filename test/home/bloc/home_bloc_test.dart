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

    group('FromWelcomeToQuestion', () {
      blocTest<HomeBloc, HomeState>(
        'emits [welcomeToAskQuestion]',
        build: buildBloc,
        act: (bloc) => bloc.add(FromWelcomeToQuestion()),
        expect: () => [
          isA<HomeState>().having(
            (element) => element.status,
            'status',
            Status.welcomeToAskQuestion,
          ),
        ],
      );
    });

    group('AskQuestion', () {
      blocTest<HomeBloc, HomeState>(
        'emits [askQuestion]',
        build: buildBloc,
        act: (bloc) => bloc.add(AskQuestion()),
        expect: () => [
          isA<HomeState>().having(
            (element) => element.status,
            'status',
            Status.askQuestion,
          ),
        ],
      );
    });

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

    group('QuestionAsked', () {
      blocTest<HomeBloc, HomeState>(
        'emits [Status.askQuestionToThinking, Status.thinkingToResults] '
        'with vertex response from _questionsRepository.getVertexResponse',
        setUp: () {
          when(() => questionsRepository.getVertexResponse(any()))
              .thenAnswer((_) async => VertexResponse.empty());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(QuestionAsked('query')),
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

    group('QuestionAskedAgain', () {
      blocTest<HomeBloc, HomeState>(
        'emits [Status.resultsToThinking, Status.thinkingToResults] '
        'with vertex response from _questionsRepository.getVertexResponse',
        setUp: () {
          when(() => questionsRepository.getVertexResponse(any()))
              .thenAnswer((_) async => VertexResponse.empty());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(QuestionAskedAgain('query')),
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

    group('Results', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.results',
        build: buildBloc,
        act: (bloc) => bloc.add(Results()),
        expect: () => [
          HomeState(status: Status.results),
        ],
      );
    });

    group('SeeSourceAnswersRequested', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.resultsToSourceAnswers',
        build: buildBloc,
        act: (bloc) => bloc.add(SeeSourceAnswersRequested('[1]')),
        expect: () => [
          HomeState(status: Status.resultsToSourceAnswers),
        ],
      );
    });

    group('SeeResultsSourceAnswers', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.seeSourceAnswers',
        build: buildBloc,
        act: (bloc) => bloc.add(SeeResultsSourceAnswers()),
        expect: () => [
          HomeState(status: Status.seeSourceAnswers),
        ],
      );
    });

    group('AnswerFeedback', () {
      blocTest<HomeBloc, HomeState>(
        'emits Status.welcome',
        build: buildBloc,
        act: (bloc) => bloc.add(AnswerFeedbackUpdated(AnswerFeedback.good)),
        expect: () => [
          HomeState(
            answerFeedback: AnswerFeedback.good,
          ),
        ],
      );
    });
  });
}
