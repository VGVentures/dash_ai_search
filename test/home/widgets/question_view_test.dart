import 'package:app_ui/app_ui.dart';
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
  group('QuestionView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: Material(child: QuestionView()),
        ),
      );

      final l10n = tester.element(find.byType(QuestionView)).l10n;

      expect(find.text(l10n.questionScreenTitle), findsOneWidget);
      expect(find.byType(QuestionInputTextField), findsOneWidget);
    });

    testWidgets(
      'calls QueryUpdated writing on the TextField',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: Material(child: QuestionView()),
          ),
        );
        const newText = 'text';
        await tester.enterText(find.byType(TextField), newText);
        verify(() => homeBloc.add(QueryUpdated(query: newText))).called(1);
      },
    );

    testWidgets(
      'calls QuestionAsked clicking on the CTAButton ',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: Material(child: QuestionView()),
          ),
        );
        await tester.tap(find.byType(CTAButton));
        verify(() => homeBloc.add(QuestionAsked())).called(1);
      },
    );
  });
}
