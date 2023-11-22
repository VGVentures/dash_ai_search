import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('WelcomeView', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        WelcomeView(),
      );

      final l10n = tester.element(find.byType(WelcomeView)).l10n;

      expect(find.text(l10n.initialScreenTitle), findsOneWidget);
      expect(find.byType(CTAButton), findsOneWidget);
    });
  });
}
