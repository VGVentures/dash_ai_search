import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        HomeView(),
      );

      expect(find.byType(Background), findsOneWidget);
      expect(find.byType(Logo), findsOneWidget);
      expect(find.byType(WelcomeView), findsOneWidget);
    });
  });
}
