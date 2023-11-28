part of 'home_bloc.dart';

enum Status {
  welcome,
  welcomeToAskQuestion,
  askQuestion,
  askQuestionToThinking,
  thinking,
  thinkingToResults,
  results,
  seeSourceAnswers,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.seeSourceAnswers,
    this.query = '',
    this.vertexResponse = const VertexResponse(
        summary:
            "asdsad dsd sad aad sadhksasd jskh dashjkd hjksdadjkh ahjkdsashjk dhjksad asdhjkd",
        documents: [
          VertexDocument(
              id: "1",
              metadata: VertexMetadata(
                  url: "url", title: "title", description: "description")),
          VertexDocument(
              id: "2",
              metadata: VertexMetadata(
                  url: "url", title: "title", description: "description")),
          VertexDocument(
              id: "3",
              metadata: VertexMetadata(
                  url: "url", title: "title", description: "description")),
          VertexDocument(
              id: "4",
              metadata: VertexMetadata(
                  url: "url", title: "title", description: "description")),
        ]),
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;
  bool get isThinkingVisible =>
      status == Status.askQuestionToThinking || status == Status.thinking;
  bool get isResultsVisible =>
      status == Status.thinkingToResults || status == Status.results;
  bool get isSeeSourceAnswersVisible => status == Status.seeSourceAnswers;
  bool get isDashVisible => [
        Status.welcome,
        Status.welcomeToAskQuestion,
        Status.askQuestion,
        Status.askQuestionToThinking,
        Status.thinkingToResults,
        Status.results,
      ].contains(status);

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
