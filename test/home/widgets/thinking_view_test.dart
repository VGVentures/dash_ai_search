import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phased/phased.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('ThinkingView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(child: ThinkingView()),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());

      expect(find.byType(CirclesAnimation), findsOneWidget);
      expect(find.byType(TextArea), findsOneWidget);
    });

    testWidgets('animates in when enter', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardEnterStatuses = tester
          .state<ThinkingViewState>(find.byType(ThinkingView))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.askQuestionToThinking]));
    });

    testWidgets('animates out when exits forward', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardExitStatuses = tester
          .state<ThinkingViewState>(find.byType(ThinkingView))
          .forwardExitStatuses;

      expect(forwardExitStatuses, equals([Status.thinkingToResults]));
    });

    group('ThinkingAnimationView', () {
      Widget bootstrap(PhasedState<ThinkingAnimationPhase> state) =>
          BlocProvider.value(
            value: homeBloc,
            child: Material(
              child: ThinkingAnimationView(
                animationState: state,
              ),
            ),
          );

      testWidgets(
        'animation changes correctly',
        (tester) async {
          final animationState = PhasedState<ThinkingAnimationPhase>(
            values: ThinkingAnimationPhase.values,
            initialValue: ThinkingAnimationPhase.initial,
          );
          final streamController = StreamController<HomeState>();
          whenListen(
            homeBloc,
            streamController.stream,
            initialState: const HomeState(),
          );

          expect(animationState.value, equals(ThinkingAnimationPhase.initial));
          await tester.pumpApp(bootstrap(animationState));

          expect(
            animationState.value,
            equals(ThinkingAnimationPhase.thinkingIn),
          );

          streamController.add(
            const HomeState(status: Status.thinkingToResults),
          );
          await tester.pump();

          expect(
            animationState.value,
            equals(ThinkingAnimationPhase.thinkingOut),
          );
        },
      );
    });
  });
}
