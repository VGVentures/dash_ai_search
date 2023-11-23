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
  });
}
