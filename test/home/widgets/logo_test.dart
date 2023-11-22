import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Logo', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Logo(),
      );

      final l10n = tester.element(find.byType(Logo)).l10n;

      expect(find.text(l10n.vertexAI), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text(l10n.flutter), findsOneWidget);
    });
  });
}
