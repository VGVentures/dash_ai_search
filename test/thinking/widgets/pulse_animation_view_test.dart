import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/thinking/thinking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('PulseAnimationView', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(
            child: PulseAnimationView(),
          ),
        );

    testWidgets(
      'animation changes correctly',
      (tester) async {
        final streamController = StreamController<HomeState>();
        whenListen(
          homeBloc,
          streamController.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());

        streamController.add(
          const HomeState(status: Status.thinkingToResults),
        );
        await tester.pump();
      },
    );
  });
}
