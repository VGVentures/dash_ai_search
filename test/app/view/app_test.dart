import 'package:flutter_test/flutter_test.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
