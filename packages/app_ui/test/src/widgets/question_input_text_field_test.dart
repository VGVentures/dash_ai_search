import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('QuestionInputTextField', () {
    testWidgets('renders correctly without animation', (tester) async {
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {},
            onTextUpdated: (_) {},
          ),
        ),
      );

      expect(find.text('hint'), findsOneWidget);
      expect(find.byType(PrimaryCTA), findsOneWidget);
    });

    testWidgets('renders correctly with animation', (tester) async {
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {},
            onTextUpdated: (_) {},
            shouldAnimate: true,
          ),
        ),
      );

      expect(find.text('hint'), findsOneWidget);
      expect(find.byType(PrimaryCTA), findsOneWidget);
      final textFieldAnimationController = tester
          .widget<AnimatedBuilder>(
            find.byKey(QuestionInputTextField.textFieldAnimatedBuilderKey),
          )
          .animation as AnimationController;
      final hintAnimationController = tester
          .widget<AnimatedBuilder>(
            find.byKey(QuestionInputTextField.hintAnimatedBuilderKey),
          )
          .animation as AnimationController;
      expect(textFieldAnimationController.status, AnimationStatus.forward);
      expect(hintAnimationController.status, AnimationStatus.dismissed);
      await tester.pump(Duration(milliseconds: 1201));
      expect(textFieldAnimationController.status, AnimationStatus.completed);
      expect(hintAnimationController.status, AnimationStatus.forward);
      await tester.pump(Duration(milliseconds: 601));
      expect(textFieldAnimationController.status, AnimationStatus.completed);
      expect(hintAnimationController.status, AnimationStatus.completed);
    });

    testWidgets('calls onTextUpdated typing on the text field', (tester) async {
      var text = '';
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
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

    testWidgets('calls onActionPressed on enter key', (tester) async {
      var called = false;
      await tester.pumpApp(
        Material(
          child: QuestionInputTextField(
            hint: 'hint',
            actionText: 'actionText',
            onActionPressed: () {
              called = true;
            },
            onTextUpdated: (_) {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(called, equals(true));
    });

    group('when shouldDisplayClearTextButton is false', () {
      testWidgets('calls onActionPressed clicking on PrimaryCTA',
          (tester) async {
        var called = false;
        await tester.pumpApp(
          Material(
            child: QuestionInputTextField(
              hint: 'hint',
              actionText: 'actionText',
              onActionPressed: () {
                called = true;
              },
              onTextUpdated: (_) {},
            ),
          ),
        );
        await tester.tap(find.byType(PrimaryCTA));

        expect(called, equals(true));
      });
    });

    group('when shouldDisplayClearTextButton is true', () {
      testWidgets('should display a clear button that clears the text field',
          (tester) async {
        await tester.pumpApp(
          Material(
            child: QuestionInputTextField(
              text: 'hello world',
              shouldDisplayClearTextButton: true,
              hint: 'hint',
              actionText: 'actionText',
              onActionPressed: () {},
              onTextUpdated: (_) {},
            ),
          ),
        );
        expect(find.text('actionText'), findsNothing);
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.text('hello world'), findsNothing);
      });
    });
  });
}
