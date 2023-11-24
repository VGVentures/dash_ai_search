import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('TertiaryCTA', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        TertiaryCTA(
          icon: Assets.icons.arrowForward.image(),
          label: 'label',
        ),
      );

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('calls onPressed when tap', (tester) async {
      var called = false;

      await tester.pumpApp(
        TertiaryCTA(
          icon: Assets.icons.arrowForward.image(),
          label: 'label',
          onPressed: () {
            called = true;
          },
        ),
      );

      await tester.tap(find.byType(TertiaryCTA));
      expect(called, isTrue);
    });
  });
}
