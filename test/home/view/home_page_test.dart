// ignore_for_file: prefer_const_constructors

import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        HomePage(),
      );

      expect(find.byType(Background), findsOneWidget);
      expect(find.byType(Logo), findsOneWidget);
      expect(find.byType(InitialScreen), findsOneWidget);
    });
  });
}
