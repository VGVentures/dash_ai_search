part of 'home_bloc.dart';

enum Status {
  welcome,
  welcomeToAskQuestion,
  askQuestion,
  askQuestionToResults,
  results,
  resultsBackToAskQuestion,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.welcome,
  });

  final Status status;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion ||
      status == Status.askQuestion ||
      status == Status.resultsBackToAskQuestion;
  bool get isResultsVisible =>
      status == Status.askQuestionToResults ||
      status == Status.results ||
      status == Status.resultsBackToAskQuestion;

  HomeState copyWith({
    Status? status,
  }) {
    return HomeState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
