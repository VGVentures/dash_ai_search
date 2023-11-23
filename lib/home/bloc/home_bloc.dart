import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:questions_repository/questions_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._questionsRepository) : super(const HomeState()) {
    on<FromWelcomeToQuestion>(_onFromWelcomeToQuestion);
    on<AskQuestion>(_onQuestion);
    on<QueryUpdated>(_queryUpdated);
    on<QuestionAsked>(_questionAsked);
  }

  final QuestionsRepository _questionsRepository;

  Future<void> _onFromWelcomeToQuestion(
    FromWelcomeToQuestion event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.welcomeToAskQuestion));
  }

  Future<void> _onQuestion(
    AskQuestion event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.askQuestion));
  }

  FutureOr<void> _queryUpdated(QueryUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }

  Future<FutureOr<void>> _questionAsked(
    QuestionAsked event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.askQuestionToThinking));
    final result = await _questionsRepository.getVertexResponse(state.query);
    emit(
      state.copyWith(
        status: Status.thinkingToResults,
        vertexResponse: result,
      ),
    );
  }
}
