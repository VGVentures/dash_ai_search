import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('PrimaryCTA', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        PrimaryCTA(
          label: 'label',
        ),
      );

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('calls onPressed when tap', (tester) async {
      var called = false;

      await tester.pumpApp(
        PrimaryCTA(
          label: 'label',
          onPressed: () {
            called = true;
          },
        ),
      );

      await tester.tap(find.byType(PrimaryCTA));
      expect(called, isTrue);
    });
  });
}
