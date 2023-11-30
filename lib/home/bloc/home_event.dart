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

class QueryUpdated extends HomeEvent {
  const QueryUpdated({required this.query});

  final String query;
  @override
  List<Object> get props => [query];
}

class QuestionAsked extends HomeEvent {
  const QuestionAsked(this.submittedQuery);

  final String submittedQuery;

  @override
  List<Object> get props => [submittedQuery];
}

class QuestionAskedAgain extends HomeEvent {
  const QuestionAskedAgain(this.submittedQuery);

  final String submittedQuery;

  @override
  List<Object> get props => [submittedQuery];
}

class Results extends HomeEvent {
  const Results();
}

class SeeSourceAnswersRequested extends HomeEvent {
  const SeeSourceAnswersRequested();
}

class SeeResultsSourceAnswers extends HomeEvent {
  const SeeResultsSourceAnswers();
}

class AnswerFeedbackUpdated extends HomeEvent {
  const AnswerFeedbackUpdated(this.answerFeedback);

  final AnswerFeedback answerFeedback;

  @override
  List<Object> get props => [answerFeedback];
}
