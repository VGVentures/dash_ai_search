import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCircularProgressIndicator', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(const AppCircularProgressIndicator());
      expect(find.byType(AppCircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders with default colors', (tester) async {
      await tester.pumpWidget(const AppCircularProgressIndicator());
      final widget = tester.widget<AppCircularProgressIndicator>(
        find.byType(AppCircularProgressIndicator),
      );
      expect(widget.color, Colors.blue);
      expect(widget.backgroundColor, Colors.white);
    });

    testWidgets('renders with provided colors', (tester) async {
      const color = Colors.black;
      const backgroundColor = Colors.blue;
      await tester.pumpWidget(
        const AppCircularProgressIndicator(
          color: color,
          backgroundColor: backgroundColor,
        ),
      );
      final widget = tester.widget<AppCircularProgressIndicator>(
        find.byType(AppCircularProgressIndicator),
      );
      expect(widget.color, color);
      expect(widget.backgroundColor, backgroundColor);
    });
  });
}
