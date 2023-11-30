part of 'home_bloc.dart';

class SummaryElement {
  SummaryElement({
    required this.text,
    required this.isLink,
  });
  final String text;
  final bool isLink;
}

class ParsedSummary {
  ParsedSummary({
    required this.elements,
  });
  final List<SummaryElement> elements;
}

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
  resultsToThinking,
  sourceAnswersBackToResults,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.welcome,
    this.query = '',
    this.vertexResponse = const VertexResponse.empty(),
    this.submittedQuery,
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;
  final String? submittedQuery;

  ParsedSummary get parsedSummary {
    final textToParse = vertexResponse.summary;
    final pattern = RegExp(r'\[[1-9]]');
    final elements = <SummaryElement>[];

    textToParse.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        elements.add(SummaryElement(text: match.group(0)!, isLink: true));
        return '';
      },
      onNonMatch: (String nonMatch) {
        elements.add(SummaryElement(text: nonMatch, isLink: false));
        return '';
      },
    );

    return ParsedSummary(elements: elements);
  }

  bool get isWelcomeVisible =>
      status == Status.welcome || status == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      status == Status.welcomeToAskQuestion || status == Status.askQuestion;
  bool get isThinkingVisible =>
      status == Status.askQuestionToThinking ||
      status == Status.thinking ||
      status == Status.thinkingToResults ||
      status == Status.resultsToThinking;
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
