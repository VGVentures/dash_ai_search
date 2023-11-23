part of 'home_bloc.dart';

enum Status {
  welcome,
  welcomeToAskQuestion,
  askQuestion,
  askQuestionToThinking,
  thinkingToResults,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.welcome,
    this.query = '',
  });

  final Status status;
  final String query;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;

  HomeState copyWith({
    Status? status,
    String? query,
  }) {
    return HomeState(
      status: status ?? this.status,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [status, query];
}
