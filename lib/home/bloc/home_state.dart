part of 'home_bloc.dart';

enum Status {
  welcome,
  welcomeToAskQuestion,
  askQuestion,
  askQuestionToThinking,
  thinkingToResults,
  results,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.welcome,
    this.query = '',
    this.vertexResponse = const VertexResponse.empty(),
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;

  bool get isThinkingVisible =>
      status == Status.askQuestionToThinking ||
      status == Status.thinkingToResults;
  bool get isResultsVisible =>
      status == Status.thinkingToResults || status == Status.results;

  HomeState copyWith({
    Status? status,
    String? query,
    VertexResponse? vertexResponse,
  }) {
    return HomeState(
      status: status ?? this.status,
      query: query ?? this.query,
      vertexResponse: vertexResponse ?? this.vertexResponse,
    );
  }

  @override
  List<Object> get props => [status, query, vertexResponse];
}
