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
      summary: 'asdasd sa',
      documents: [
        VertexDocument(
          id: '1',
          metadata: VertexMetadata(
            url: 'url',
            title: 'Average page title is 45 characters  | Flutter',
            description:
                'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.',
          ),
        ),
        VertexDocument(
          id: '2',
          metadata: VertexMetadata(
            url: 'url',
            title: 'Average page title is 45 characters  | Flutter',
            description:
                'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.',
          ),
        ),
        VertexDocument(
          id: '3',
          metadata: VertexMetadata(
            url: 'url',
            title: 'Average page title is 45 characters  | Flutter',
            description:
                'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.',
          ),
        ),
        VertexDocument(
          id: '4',
          metadata: VertexMetadata(
            url: 'url',
            title: 'Average page title is 45 characters  | Flutter',
            description:
                'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.',
          ),
        ),
      ],
    ),
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
