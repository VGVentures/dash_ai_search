import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    test('FromWelcomeToQuestion supports value equality', () {
      expect(
        FromWelcomeToQuestion(),
        equals(FromWelcomeToQuestion()),
      );
    });

    test('AskQuestion supports value equality', () {
      expect(
        AskQuestion(),
        equals(AskQuestion()),
      );
    });

    test('QueryUpdated supports value equality', () {
      expect(
        QueryUpdated(query: 'query'),
        equals(QueryUpdated(query: 'query')),
      );
    });

    test('QuestionAsked supports value equality', () {
      expect(
        QuestionAsked(),
        equals(QuestionAsked()),
      );
    });

    test('Results supports value equality', () {
      expect(
        Results(),
        equals(Results()),
      );
    });

    test('SeeSourceAnswersRequested supports value equality', () {
      expect(
        SeeSourceAnswersRequested(),
        equals(SeeSourceAnswersRequested()),
      );
    });

    test('SeeResultsSourceAnswers supports value equality', () {
      expect(
        SeeResultsSourceAnswers(),
        equals(SeeResultsSourceAnswers()),
      );
    });

    test('Restarted supports value equality', () {
      expect(
        Restarted(),
        equals(Restarted()),
      );
    });
  });
}
