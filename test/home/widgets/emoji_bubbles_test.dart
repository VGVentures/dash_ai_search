import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('EmojiBubbles', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();

      whenListen(
        homeBloc,
        Stream.fromIterable([const HomeState()]),
        initialState: const HomeState(),
      );
    });

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: const MaterialApp(
            home: Scaffold(
              body: EmojiBubbles(),
            ),
          ),
        );

    testWidgets('renders', (tester) async {
      await tester.pumpApp(bootstrap());

      expect(find.byType(EmojiBubbles), findsOneWidget);
    });

    testWidgets(
      'when receiving a positive feedback, spawn emojis with '
      'cellebration images',
      (tester) async {
        final controller = StreamController<HomeState>();

        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());

        controller.add(const HomeState(answerFeedbacks: [AnswerFeedback.good]));

        await tester.pump();

        expect(find.byType(EmojiBubble), findsWidgets);

        final widgets = tester.widgetList(find.byType(EmojiBubble)).toList();

        for (final widget in widgets) {
          expect(widget, isA<EmojiBubble>());
          expect(
            EmojiBubbles.cellebrateImages,
            contains((widget as EmojiBubble).bubble.emoji),
          );
        }

        for (var i = 0; i < 10; i++) {
          await tester.pump();
        }
      },
    );

    testWidgets(
      'when receiving a negative feedback, spawn emojis with '
      'depressing images',
      (tester) async {
        final controller = StreamController<HomeState>();

        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());

        controller.add(const HomeState(answerFeedbacks: [AnswerFeedback.bad]));

        await tester.pump();

        expect(find.byType(EmojiBubble), findsWidgets);

        final widgets = tester.widgetList(find.byType(EmojiBubble)).toList();

        for (final widget in widgets) {
          expect(widget, isA<EmojiBubble>());
          expect(
            EmojiBubbles.beDepressedImages,
            contains((widget as EmojiBubble).bubble.emoji),
          );
        }

        for (var i = 0; i < 10; i++) {
          await tester.pump();
        }
      },
    );

    testWidgets(
      'there are no bubbles anymore when the anymation is over',
      (tester) async {
        final controller = StreamController<HomeState>();

        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());

        controller.add(const HomeState(answerFeedbacks: [AnswerFeedback.good]));

        final state =
            tester.state<EmojiBubblesState>(find.byType(EmojiBubbles));

        for (var i = 0; i < 100; i++) {
          state.update(1);
          await tester.pump();
        }

        expect(find.byType(EmojiBubble), findsNothing);
      },
    );
  });
}
