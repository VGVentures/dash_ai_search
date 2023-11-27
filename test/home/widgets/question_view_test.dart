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

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(child: QuestionView()),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());

      final l10n = tester.element(find.byType(QuestionView)).l10n;

      expect(find.text(l10n.questionScreenTitle), findsOneWidget);
      expect(find.byType(QuestionInputTextField), findsOneWidget);
    });

    testWidgets('animates in when enter', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardEnterStatuses = tester
          .state<QuestionViewState>(find.byType(QuestionView))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.welcomeToAskQuestion]));
    });

    testWidgets('animates out when exits forward', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardExitStatuses = tester
          .state<QuestionViewState>(find.byType(QuestionView))
          .forwardExitStatuses;

      expect(forwardExitStatuses, equals([Status.askQuestionToThinking]));
    });

    testWidgets(
      'calls AskQuestion writing on enter',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        await tester.pumpAndSettle();
        verify(() => homeBloc.add(AskQuestion())).called(1);
      },
    );

    testWidgets(
      'calls QueryUpdated writing on the TextField',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        const newText = 'text';
        await tester.enterText(find.byType(TextField), newText);
        verify(() => homeBloc.add(QueryUpdated(query: newText))).called(1);
      },
    );

    testWidgets(
      'calls QuestionAsked clicking on the PrimaryCTA ',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        await tester.tap(find.byType(PrimaryCTA));
        verify(() => homeBloc.add(QuestionAsked())).called(1);
      },
    );
  });
}