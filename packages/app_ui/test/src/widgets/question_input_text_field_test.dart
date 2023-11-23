import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('QuestionInputTextField', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        QuestionInputTextField(
          icon: SizedBox.shrink(
            key: Key('iconKey'),
          ),
          hint: 'hint',
          action: SizedBox.shrink(
            key: Key('actionKey'),
          ),
        ),
      );

      expect(find.byKey(Key('iconKey')), findsOneWidget);
      expect(find.text('hint'), findsOneWidget);
      expect(find.byKey(Key('actionKey')), findsOneWidget);
    });
  });
}
