part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeNavigated extends HomeEvent {
  const HomeNavigated(this.status);

  final Status status;

  @override
  List<Object> get props => [status];
}

class QueryUpdated extends HomeEvent {
  const QueryUpdated({required this.query});

  final String query;
  @override
  List<Object> get props => [query];
}

class HomeQuestionAsked extends HomeEvent {
  const HomeQuestionAsked(this.submittedQuery);

  final String submittedQuery;

  @override
  List<Object> get props => [submittedQuery];
}

class HomeQuestionAskedAgain extends HomeEvent {
  const HomeQuestionAskedAgain(this.submittedQuery);

  final String submittedQuery;

  @override
  List<Object> get props => [submittedQuery];
}

class HomeSeeSourceAnswersRequested extends HomeEvent {
  const HomeSeeSourceAnswersRequested(this.index);

  final String? index;

  @override
  List<Object?> get props => [index];
}

class HomeAnswerFeedbackAdded extends HomeEvent {
  const HomeAnswerFeedbackAdded(this.answerFeedback);

  final AnswerFeedback answerFeedback;

  @override
  List<Object> get props => [answerFeedback];
}

class HomeSourceAnswersNavigated extends HomeEvent {
  const HomeSourceAnswersNavigated(this.index);

  final String index;

  @override
  List<Object?> get props => [index];
}

class HomeBackToAiSummaryTapped extends HomeEvent {
  const HomeBackToAiSummaryTapped();

  @override
  List<Object?> get props => [];
}
