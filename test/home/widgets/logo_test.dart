import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('Logo', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Logo(),
      );

      final l10n = tester.element(find.byType(Logo)).l10n;

      expect(find.text(l10n.vertexAI), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text(l10n.flutter), findsOneWidget);
    });

    testWidgets(
      'calls Restarted clicking on the logo ',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: Logo(),
          ),
        );
        await tester.tap(find.byType(LogoIcon));
        verify(() => homeBloc.add(Restarted())).called(1);
      },
    );
  });
}
