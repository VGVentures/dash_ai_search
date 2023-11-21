import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAnimatedCrossFade', () {
    testWidgets('renders both children', (tester) async {
      await tester.pumpWidget(
        const AppAnimatedCrossFade(
          firstChild: SizedBox(key: Key('first')),
          secondChild: SizedBox(key: Key('second')),
          crossFadeState: CrossFadeState.showFirst,
        ),
      );
      expect(find.byKey(const Key('first')), findsOneWidget);
      expect(find.byKey(const Key('second')), findsOneWidget);
    });
  });
}
