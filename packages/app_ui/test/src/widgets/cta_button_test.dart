import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CTAButton', () {
    Widget bootstrap({
      required Widget child,
    }) {
      return MaterialApp(home: child);
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        bootstrap(
          child: CTAButton(
            icon: Assets.icons.arrowForward.image(),
            label: 'label',
          ),
        ),
      );

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('calls onPressed when tap', (tester) async {
      var called = false;

      await tester.pumpWidget(
        bootstrap(
          child: CTAButton(
            icon: Assets.icons.arrowForward.image(),
            label: 'label',
            onPressed: () {
              called = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(CTAButton));
      expect(called, isTrue);
    });
  });
}
