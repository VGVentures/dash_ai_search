part of 'home_bloc.dart';

enum Status {
  welcome,
  welcomeToAskQuestion,
  askQuestion,
  askQuestionToThinking,
  thinking,
  thinkingToResults,
  results,
  resultsToSourceAnswers,
  seeSourceAnswers,
  sourceAnswersBackToResults,
}

enum AnswerFeedback {
  good,
  bad,
  none,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.welcome,
    this.query = '',
    this.vertexResponse = const VertexResponse.empty(),
    this.submittedQuery,
    this.answerFeedback = AnswerFeedback.none,
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;
  final String? submittedQuery;
  final AnswerFeedback answerFeedback;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;
  bool get isThinkingVisible =>
      status == Status.askQuestionToThinking ||
      status == Status.thinking ||
      status == Status.thinkingToResults;
  bool get isResultsVisible =>
      status == Status.thinkingToResults ||
      status == Status.results ||
      status == Status.resultsToSourceAnswers ||
      status == Status.seeSourceAnswers;
  bool get isSeeSourceAnswersVisible => status == Status.seeSourceAnswers;
  bool get isDashVisible => [
        Status.welcome,
        Status.welcomeToAskQuestion,
        Status.askQuestion,
        Status.askQuestionToThinking,
        Status.thinkingToResults,
        Status.results,
        Status.resultsToSourceAnswers,
      ].contains(status);

  HomeState copyWith({
    Status? status,
    String? query,
    VertexResponse? vertexResponse,
    String? submittedQuery,
    AnswerFeedback? answerFeedback,
  }) {
    return HomeState(
      status: status ?? this.status,
      query: query ?? this.query,
      vertexResponse: vertexResponse ?? this.vertexResponse,
      submittedQuery: submittedQuery ?? this.submittedQuery,
      answerFeedback: answerFeedback ?? this.answerFeedback,
    );
  }

  @override
  List<Object> get props => [status, query, vertexResponse, answerFeedback];
}
