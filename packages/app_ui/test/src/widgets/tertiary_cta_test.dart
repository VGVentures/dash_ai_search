import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
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

    testWidgets('animates on hover', (tester) async {
      await tester.pumpApp(
        TertiaryCTA(
          icon: Assets.icons.arrowForward.image(),
          label: 'label',
          onPressed: () {},
        ),
      );
      var status = AnimationStatus.dismissed;
      final widget = tester
          .widget<DecoratedBoxTransition>(find.byType(DecoratedBoxTransition));
      widget.decoration.addStatusListener((newstatus) {
        status = newstatus;
      });
      final center = tester.getCenter(find.byType(TertiaryCTA));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(center);
      expect(status, AnimationStatus.forward);
      await tester.pumpAndSettle();
      expect(status, AnimationStatus.completed);
      await gesture.moveTo(Offset(1000, 1000));
      expect(status, AnimationStatus.reverse);
      await tester.pumpAndSettle();
      expect(status, AnimationStatus.dismissed);
    });
  });
}
