import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackButtons', () {
    testWidgets(
      'triggers onLike when the like button is pressed',
      (tester) async {
        var wasPressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeedbackButtons(
                onLike: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        );
        await tester.tap(find.image(vertexImages.thumbUp.image().image));
        await tester.pumpAndSettle();
        expect(wasPressed, isTrue);
      },
    );

    testWidgets(
      'triggers onDislike when the dislike button is pressed',
      (tester) async {
        var wasPressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeedbackButtons(
                onDislike: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        );
        await tester.tap(find.image(vertexImages.thumbDown.image().image));
        await tester.pumpAndSettle();
        expect(wasPressed, isTrue);
      },
    );
  });
}
