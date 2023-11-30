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

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.seeSourceAnswers,
    this.query = '',
    this.vertexResponse = const VertexResponse(summary: "asd", documents: [
      VertexDocument(
        id: '1',
        metadata: VertexMetadata(
          url: 'url',
          title: 'title',
          description: 'description',
        ),
      ),
      VertexDocument(
        id: '2',
        metadata: VertexMetadata(
          url: 'url',
          title: 'title',
          description: 'description',
        ),
      ),
      VertexDocument(
        id: '3',
        metadata: VertexMetadata(
          url: 'url',
          title: 'title',
          description: 'description',
        ),
      ),
      VertexDocument(
        id: '4',
        metadata: VertexMetadata(
          url: 'url',
          title: 'title',
          description: 'description',
        ),
      ),
    ]),
    this.submittedQuery,
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;
  final String? submittedQuery;

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
  }) {
    return HomeState(
      status: status ?? this.status,
      query: query ?? this.query,
      vertexResponse: vertexResponse ?? this.vertexResponse,
      submittedQuery: submittedQuery ?? this.submittedQuery,
    );
  }

  @override
  List<Object> get props => [status, query, vertexResponse];
}
