import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FromWelcomeToQuestion>(_onFromWelcomeToQuestion);
    on<AskQuestion>(_onAskQuestion);
    on<FromAskQuestionToResults>(_onFromAskQuestionToResults);
    on<AskQuestionAgain>(_onAskQuestionAgain);
  }

  Future<void> _onFromWelcomeToQuestion(
    FromWelcomeToQuestion event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.welcomeToAskQuestion));
  }

  Future<void> _onAskQuestion(
    AskQuestion event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.askQuestion));
  }

  Future<void> _onFromAskQuestionToResults(
    FromAskQuestionToResults event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.askQuestionToResults));
  }

  Future<void> _onAskQuestionAgain(
    AskQuestionAgain event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: Status.resultsBackToAskQuestion));
  }
}
