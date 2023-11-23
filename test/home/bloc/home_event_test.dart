import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeEvent', () {
    test('FromWelcomeToQuestion supports value equality', () {
      expect(
        FromWelcomeToQuestion(),
        FromWelcomeToQuestion(),
      );
    });

    test('AskQuestion supports value equality', () {
      expect(
        AskQuestion(),
        AskQuestion(),
      );
    });
  });
}
