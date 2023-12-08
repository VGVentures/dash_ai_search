import 'package:dash_ai_search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FixedViewport', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FixedViewport(
            child: Text('Hello'),
          ),
        ),
      );
      expect(find.byType(FixedViewport), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets(
      'renders when resolution is bigger than screen',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: FixedViewport(
              resolution: const Size(4000, 3000),
              child: Text('Hello'),
            ),
          ),
        );
        expect(find.byType(FixedViewport), findsOneWidget);
        expect(find.text('Hello'), findsOneWidget);
      },
    );
  });
}
