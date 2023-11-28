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
  group('Background', () {
    late HomeBloc homeBloc;
    PhasedState<BackgroundPhase>? backgroundState;

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Background(
            backgroundState: backgroundState,
          ),
        );

    setUp(() {
      homeBloc = _MockHomeBloc();

      whenListen(
        homeBloc,
        Stream.fromIterable(const <HomeState>[]),
        initialState: const HomeState(),
      );
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());

      expect(find.byType(Circle), findsNWidgets(6));
    });

    testWidgets('moves the animation correctly', (tester) async {
      backgroundState = PhasedState<BackgroundPhase>(
        values: BackgroundPhase.values,
        initialValue: BackgroundPhase.initial,
        autostart: false,
      );
      await tester.pumpApp(bootstrap());

      expect(backgroundState?.value, equals(BackgroundPhase.circlesIn));
    });

    testWidgets(
      'moves the animation correctly when the bloc moves to '
      'the next state',
      (tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(),
        );
        backgroundState = PhasedState<BackgroundPhase>(
          values: BackgroundPhase.values,
          initialValue: BackgroundPhase.initial,
          autostart: false,
        );
        await tester.pumpApp(bootstrap());

        expect(backgroundState?.value, equals(BackgroundPhase.circlesIn));

        controller.add(const HomeState(status: Status.welcomeToAskQuestion));
        await tester.pump();

        expect(backgroundState?.value, equals(BackgroundPhase.circlesOut));
      },
    );

    test('verifies should not repaint', () async {
      final circlePainter = CirclePainter(
        radius: 10,
        borderColor: Colors.white,
        dotted: false,
        backgroundColor: Colors.white,
      );
      expect(circlePainter.shouldRepaint(circlePainter), false);
    });
  });
}
