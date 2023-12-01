import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';

class _MockQuestionsRepository extends Mock implements QuestionsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('App', () {
    late QuestionsRepository questionsRepository;
    late DashAnimations dashAnimations;

    setUp(() async {
      questionsRepository = _MockQuestionsRepository();
      dashAnimations = DashAnimations();
      await dashAnimations.load();
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          questionsRepository: questionsRepository,
          dashAnimations: dashAnimations,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
