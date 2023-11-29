import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phased/phased.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('DashAnimationContainer', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();

      whenListen(
        homeBloc,
        Stream.fromIterable(const <HomeState>[]),
        initialState: const HomeState(),
      );
    });

    Widget bootstrap([PhasedState<DashAnimationPhase>? animationState]) =>
        BlocProvider.value(
          value: homeBloc,
          child: DashAnimationContainer(
            animationState: animationState,
          ),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());

      expect(find.byType(DashAnimation), findsOneWidget);
    });

    testWidgets('updates the animation state correctly', (tester) async {
      final state = PhasedState<DashAnimationPhase>(
        values: DashAnimationPhase.values,
        initialValue: DashAnimationPhase.initial,
      );

      final animationController = StreamController<HomeState>();
      whenListen(
        homeBloc,
        animationController.stream,
        initialState: const HomeState(),
      );

      expect(state.value, equals(DashAnimationPhase.initial));
      await tester.pumpApp(bootstrap(state));

      expect(state.value, equals(DashAnimationPhase.dashIn));

      animationController.add(
        const HomeState(status: Status.askQuestionToThinking),
      );
      await tester.pump();

      expect(state.value, equals(DashAnimationPhase.dashOut));

      animationController.add(
        const HomeState(status: Status.thinkingToResults),
      );
      await tester.pump();

      expect(state.value, equals(DashAnimationPhase.dashIn));

      animationController.add(
        const HomeState(status: Status.resultsToSourceAnswers),
      );
      await tester.pump();

      expect(state.value, equals(DashAnimationPhase.dashOut));
    });
  });
}
