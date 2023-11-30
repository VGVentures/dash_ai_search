import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  group('Logo', () {
    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(Logo());

      final l10n = tester.element(find.byType(Logo)).l10n;

      expect(find.text(l10n.vertexAI), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text(l10n.flutter), findsOneWidget);
    });

    testWidgets('opens the Vertex website when tapped', (tester) async {
      final mockLauncher = _MockUrlLauncher();
      UrlLauncherPlatform.instance = mockLauncher;
      when(
        () => mockLauncher.launchUrl(any(), any()),
      ).thenAnswer((_) async => true);
      await tester.pumpApp(Logo());
      await tester.tap(find.byType(Logo));
      verify(() => mockLauncher.launchUrl(any(), any())).called(1);
    });
  });
}
