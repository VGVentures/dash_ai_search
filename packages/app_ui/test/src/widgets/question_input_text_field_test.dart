import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('QuestionInputTextField', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            icon: SizedBox.shrink(),
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {},
            onTextUpdated: (_) {},
          ),
        ),
      );

      expect(find.text('hint'), findsOneWidget);
      expect(find.byType(CTAButton), findsOneWidget);
    });

    testWidgets('calls onTextUpdated typing on the text field', (tester) async {
      var text = '';
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            icon: SizedBox.shrink(),
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {},
            onTextUpdated: (newText) {
              text = newText;
            },
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'test');
      expect(text, equals('test'));
    });

    testWidgets('calls onActionPressed clicking on CTAButton', (tester) async {
      var called = false;
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            icon: SizedBox.shrink(),
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {
              called = true;
            },
            onTextUpdated: (_) {},
          ),
        ),
      );
      await tester.tap(find.byType(CTAButton));

      expect(called, equals(true));
    });
  });
}
