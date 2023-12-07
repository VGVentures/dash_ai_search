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

enum AnswerFeedback {
  good,
  bad,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.askQuestion,
    this.query = '',
    this.vertexResponse = const VertexResponse.empty(),
    this.submittedQuery,
    this.selectedIndex = 0,
    this.answerFeedbacks = const [],
  });

  final Status status;
  final String query;
  final VertexResponse vertexResponse;
  final String? submittedQuery;
  final int selectedIndex;
  final List<AnswerFeedback> answerFeedbacks;

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

  HomeState copyWith({
    Status? status,
    String? query,
    VertexResponse? vertexResponse,
    String? submittedQuery,
    int? selectedIndex,
    List<AnswerFeedback>? answerFeedbacks,
  }) {
    return HomeState(
      status: status ?? this.status,
      query: query ?? this.query,
      vertexResponse: vertexResponse ?? this.vertexResponse,
      submittedQuery: submittedQuery ?? this.submittedQuery,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      answerFeedbacks: answerFeedbacks ?? this.answerFeedbacks,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        vertexResponse,
        selectedIndex,
        submittedQuery,
        answerFeedbacks,
      ];
}

extension StatusX on Status {
  bool get isWelcomeVisible =>
      this == Status.welcome || this == Status.welcomeToAskQuestion;
  bool get isQuestionVisible =>
      this == Status.welcomeToAskQuestion ||
      this == Status.askQuestion ||
      this == Status.askQuestionToThinking;
  bool get isThinkingVisible =>
      this == Status.askQuestionToThinking ||
      this == Status.thinking ||
      this == Status.thinkingToResults ||
      this == Status.resultsToThinking;
  bool get isResultsVisible =>
      this == Status.thinkingToResults ||
      this == Status.results ||
      this == Status.resultsToSourceAnswers ||
      this == Status.seeSourceAnswers ||
      this == Status.sourceAnswersBackToResults;
  bool get isMovingToSeeSourceAnswers =>
      this == Status.resultsToSourceAnswers ||
      this == Status.seeSourceAnswers ||
      this == Status.sourceAnswersBackToResults;
  bool get isSeeSourceAnswersVisible => this == Status.seeSourceAnswers;
  bool get isDashOnLeft =>
      this == Status.welcome ||
      this == Status.welcomeToAskQuestion ||
      this == Status.askQuestion ||
      this == Status.askQuestionToThinking ||
      this == Status.thinking ||
      this == Status.thinkingToResults ||
      this == Status.results;
  bool get isDashOnRight =>
      this == Status.resultsToSourceAnswers ||
      this == Status.seeSourceAnswers ||
      this == Status.sourceAnswersBackToResults;
}
