import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Background', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Background(),
      );

      expect(find.byType(Circle), findsNWidgets(6));
    });

    test('verifies should not repaint', () async {
      final circlePainter = CirclePainter(
        offset: Offset.zero,
        radius: 10,
        borderColor: Colors.white,
        dotted: false,
      );
      expect(circlePainter.shouldRepaint(circlePainter), false);
    });
  });
}
