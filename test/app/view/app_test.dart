import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';

class _MockQuestionsRepository extends Mock implements QuestionsRepository {}

void main() {
  group('App', () {
    late QuestionsRepository questionsRepository;

    setUp(() {
      questionsRepository = _MockQuestionsRepository();
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          questionsRepository: questionsRepository,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
