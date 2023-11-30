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
    on<QuestionAskedAgain>(_questionAskedAgain);
    on<Results>(_onResults);
    on<SeeSourceAnswersRequested>(_onSeeSourceAnswersRequested);
    on<SeeResultsSourceAnswers>(_onSeeSourceAnswers);
    on<AnswerFeedbackUpdated>(_onAnswerFeedbackUpdated);
  }

  final QuestionsRepository _questionsRepository;

  void _onFromWelcomeToQuestion(
    FromWelcomeToQuestion event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.welcomeToAskQuestion));
  }

  void _onQuestion(
    AskQuestion event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.askQuestion));
  }

  void _queryUpdated(QueryUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _questionAsked(
    QuestionAsked event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.askQuestionToThinking,
        submittedQuery: event.submittedQuery,
      ),
    );
    await _emitVertexResponse(emit);
  }

  Future<void> _questionAskedAgain(
    QuestionAskedAgain event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.resultsToThinking,
        submittedQuery: event.submittedQuery,
      ),
    );
    await _emitVertexResponse(emit);
  }

  Future<void> _emitVertexResponse(Emitter<HomeState> emit) async {
    final result = await _questionsRepository.getVertexResponse(state.query);
    emit(
      state.copyWith(
        status: Status.thinkingToResults,
        vertexResponse: result,
      ),
    );
  }

  void _onResults(
    Results event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.results));
  }

  void _onSeeSourceAnswersRequested(
    SeeSourceAnswersRequested event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.resultsToSourceAnswers));
  }

  void _onSeeSourceAnswers(
    SeeResultsSourceAnswers event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.seeSourceAnswers));
  }

  void _onAnswerFeedbackUpdated(
    AnswerFeedbackUpdated event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(answerFeedback: event.answerFeedback));
  }
}
