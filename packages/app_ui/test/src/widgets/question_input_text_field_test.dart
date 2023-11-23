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
          ),
        ),
      );

      expect(find.text('hint'), findsOneWidget);
      expect(find.byType(CTAButton), findsOneWidget);
    });
  });
}
