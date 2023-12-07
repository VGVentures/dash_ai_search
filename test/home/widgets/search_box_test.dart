import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('SearchBox', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    Widget bootstrap({bool askAgain = false}) => BlocProvider.value(
          value: homeBloc,
          child: Material(
            child: SearchBox(
              askAgain: askAgain,
            ),
          ),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());
      expect(find.byType(QuestionInputTextField), findsOneWidget);
    });

    testWidgets(
      'calls HomeQueryUpdated writing on the TextField',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        const newText = 'text';
        await tester.enterText(find.byType(TextField), newText);
        verify(() => homeBloc.add(HomeQueryUpdated(query: newText))).called(1);
      },
    );

    testWidgets(
      'calls HomeQuestionAsked clicking on the PrimaryCTA '
      'when askAgain is false',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        await tester.tap(find.byType(PrimaryCTA));
        verify(() => homeBloc.add(HomeQuestionAsked(''))).called(1);
      },
    );

    testWidgets(
      'calls HomeQuestionAskedAgain clicking on the PrimaryCTA '
      'when askAgain is true',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap(askAgain: true));
        await tester.tap(find.byType(PrimaryCTA));
        verify(() => homeBloc.add(HomeQuestionAskedAgain(''))).called(1);
      },
    );
  });
}
