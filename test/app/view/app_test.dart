import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';

class _MockBuildContext extends Mock implements BuildContext {}

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

    group('onGenerateRoute', () {
      test('returns a route', () {
        final route = onGenerateRoute(const RouteSettings(name: '/'));
        expect(route, isA<MaterialPageRoute<dynamic>>());
      });

      test(
        'returns a route withuout FixedViewport when there is no resolution '
        'in the name',
        () {
          final route = onGenerateRoute(const RouteSettings(name: '/'));

          final widget = route.builder(_MockBuildContext());
          expect(widget, isA<HomePage>());
        },
      );

      test(
        'returns a route with FixedViewport when there is a resolution '
        'in the name',
        () {
          final route = onGenerateRoute(const RouteSettings(name: '1280x720'));

          final widget = route.builder(_MockBuildContext());
          expect(widget, isA<FixedViewport>());
          expect((widget as FixedViewport).resolution, const Size(1280, 720));
        },
      );
    });
  });
}
