part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FromWelcomeToQuestion extends HomeEvent {
  const FromWelcomeToQuestion();
}

class AskQuestion extends HomeEvent {
  const AskQuestion();
}

class FromAskQuestionToResults extends HomeEvent {
  const FromAskQuestionToResults();
}

class AskQuestionAgain extends HomeEvent {
  const AskQuestionAgain();
}
