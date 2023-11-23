import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<FromWelcomeToQuestion>(_onFromWelcomeToQuestion);
    on<AskQuestion>(_onQuestion);
  }

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
}
