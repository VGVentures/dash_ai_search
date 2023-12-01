import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PrimaryIconCTA', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PrimaryIconCTA(
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
        MaterialApp(
          home: PrimaryIconCTA(
            icon: Assets.icons.arrowForward.image(),
            label: 'label',
            onPressed: () {
              called = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryIconCTA));
      expect(called, isTrue);
    });

    testWidgets('has hover animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PrimaryIconCTA(
            icon: Assets.icons.arrowForward.image(),
            label: 'label',
            onPressed: () {},
          ),
        ),
      );
      final animationController = tester
          .widget<AnimatedBuilder>(
            find.byKey(PrimaryIconCTA.animatedBuilderKey),
          )
          .animation as AnimationController;

      final center = tester.getCenter(find.byType(PrimaryIconCTA));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(center);
      expect(animationController.status, AnimationStatus.forward);
      await tester.pumpAndSettle();
      expect(animationController.status, AnimationStatus.completed);
      await gesture.moveTo(Offset(1000, 1000));
      expect(animationController.status, AnimationStatus.reverse);
      await tester.pumpAndSettle();
      expect(animationController.status, AnimationStatus.dismissed);
    });
  });
}
