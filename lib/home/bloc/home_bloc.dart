import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:questions_repository/questions_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._questionsRepository) : super(const HomeState()) {
    on<HomeNavigated>(_onHomeNavigated);
    on<HomeQueryUpdated>(_onHomeQueryUpdated);
    on<HomeQuestionAsked>(_onHomeQuestionAsked);
    on<HomeQuestionAskedAgain>(_onHomeQuestionAskedAgain);
    on<HomeSeeSourceAnswersRequested>(_onHomeSeeSourceAnswersRequested);
    on<HomeAnswerFeedbackAdded>(_onHomeAnswerFeedbackAdded);
    on<HomeSourceAnswersNavigated>(_onHomeSourceAnswersNavigated);
    on<HomeBackToAiSummaryTapped>(_onHomeBackToAiSummaryTapped);
  }

  final QuestionsRepository _questionsRepository;

  void _onHomeNavigated(
    HomeNavigated event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _onHomeQueryUpdated(HomeQueryUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _onHomeQuestionAsked(
    HomeQuestionAsked event,
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

  Future<void> _onHomeQuestionAskedAgain(
    HomeQuestionAskedAgain event,
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

  void _onHomeSeeSourceAnswersRequested(
    HomeSeeSourceAnswersRequested event,
    Emitter<HomeState> emit,
  ) {
    final indexParsed = event.index != null ? _getIndex(event.index!) : 0;
    emit(
      state.copyWith(
        status: Status.resultsToSourceAnswers,
        selectedIndex: indexParsed,
      ),
    );
  }

  void _onHomeAnswerFeedbackAdded(
    HomeAnswerFeedbackAdded event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        answerFeedbacks: [
          ...state.answerFeedbacks,
          event.answerFeedback,
        ],
      ),
    );
  }

  FutureOr<void> _onHomeSourceAnswersNavigated(
    HomeSourceAnswersNavigated event,
    Emitter<HomeState> emit,
  ) {
    final indexParsed = _getIndex(event.index);
    emit(
      state.copyWith(
        selectedIndex: indexParsed,
      ),
    );
  }

  void _onHomeBackToAiSummaryTapped(
    HomeBackToAiSummaryTapped event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: Status.sourceAnswersBackToResults));
  }

  int _getIndex(String textIndex) {
    return int.parse(textIndex.replaceAll('[', '').replaceAll(']', '')) - 1;
  }
}
