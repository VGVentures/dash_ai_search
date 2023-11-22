// ignore_for_file: prefer_const_constructors

import 'package:dash_ai_search/gen/assets.gen.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CTAButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        CTAButton(
          icon: Assets.icons.arrowForward.image(),
          label: 'label',
          onPressed: () {},
        ),
      );

      expect(find.text('label'), findsOneWidget);
    });

    testWidgets('calls onPressed when tap', (tester) async {
      var called = false;

      await tester.pumpApp(
        CTAButton(
          icon: Assets.icons.arrowForward.image(),
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
