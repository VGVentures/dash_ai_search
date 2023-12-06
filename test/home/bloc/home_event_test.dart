import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    test('QueryUpdated supports value equality', () {
      expect(
        QueryUpdated(query: 'query'),
        equals(QueryUpdated(query: 'query')),
      );
    });

    test('HomeQuestionAsked supports value equality', () {
      expect(
        HomeQuestionAsked('query'),
        equals(HomeQuestionAsked('query')),
      );
    });

    test('HomeQuestionAskedAgain supports value equality', () {
      expect(
        HomeQuestionAskedAgain('query'),
        equals(HomeQuestionAskedAgain('query')),
      );
    });

    test('HomeSeeSourceAnswersRequested supports value equality', () {
      expect(
        HomeSeeSourceAnswersRequested('[1]'),
        equals(HomeSeeSourceAnswersRequested('[1]')),
      );
    });

    test('HomeAnswerFeedbackAdded supports value equality', () {
      expect(
        HomeAnswerFeedbackAdded(AnswerFeedback.good),
        equals(HomeAnswerFeedbackAdded(AnswerFeedback.good)),
      );
    });

    test('HomeNavigated supports value equality', () {
      expect(
        HomeNavigated(Status.askQuestion),
        equals(HomeNavigated(Status.askQuestion)),
      );
    });

    test('HomeBackToAiSummaryTapped supports value equality', () {
      expect(
        HomeBackToAiSummaryTapped(),
        equals(HomeBackToAiSummaryTapped()),
      );
    });
  });
}
