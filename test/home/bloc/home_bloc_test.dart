import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeBloc', () {
    group('FromWelcomeToQuestion', () {
      blocTest<HomeBloc, HomeState>(
        'emits [welcomeToAskQuestion] when FromWelcomeToQuestion',
        build: HomeBloc.new,
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
        'emits [askQuestion] when AskQuestion',
        build: HomeBloc.new,
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
