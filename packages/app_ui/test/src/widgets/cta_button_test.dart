import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('CTAButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        CTAButton(
          icon: Assets.icons.arrowForward,
          label: 'label',
        ),
      );

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('calls onPressed when tap', (tester) async {
      var called = false;

      await tester.pumpApp(
        CTAButton(
          icon: Assets.icons.arrowForward,
          label: 'label',
          onPressed: () {
            called = true;
          },
        ),
      );

      await tester.tap(find.byType(CTAButton));
      expect(called, isTrue);
    });
  });
}
