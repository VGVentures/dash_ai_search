import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/transition_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

class _MockAnimationController extends Mock implements AnimationController {}

class SampleWidget extends StatefulWidget {
  const SampleWidget({
    required this.mockedEnterTransitionController,
    required this.mockedExitTransitionController,
    super.key,
  });

  final AnimationController mockedEnterTransitionController;
  final AnimationController mockedExitTransitionController;

  @override
  State<SampleWidget> createState() => _SampleWidgetState();
}

class _SampleWidgetState extends State<SampleWidget>
    with SingleTickerProviderStateMixin, TransitionScreenMixin {
  @override
  List<Status> get forwardEnterStatuses => [Status.welcome];

  @override
  List<Status> get forwardExitStatuses => [Status.welcomeToAskQuestion];

  @override
  List<Status> get backEnterStatuses => [Status.askQuestion];

  @override
  List<Status> get backExitStatuses => [Status.askQuestionToThinking];

  @override
  void initializeTransitionController() {
    enterTransitionController = widget.mockedEnterTransitionController;
    exitTransitionController = widget.mockedExitTransitionController;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  group('TransitionScreenMixin', () {
    late HomeBloc homeBloc;
    late AnimationController enterAnimationController;
    late AnimationController exitAnimationController;

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());

      enterAnimationController = _MockAnimationController();
      when(() => enterAnimationController.forward())
          .thenAnswer((invocation) => TickerFuture.complete());
      when(() => enterAnimationController.reverse())
          .thenAnswer((invocation) => TickerFuture.complete());
      when(() => enterAnimationController.addStatusListener(any()))
          .thenAnswer((invocation) {});
      when(() => enterAnimationController.dispose())
          .thenAnswer((invocation) {});

      exitAnimationController = _MockAnimationController();
      when(() => exitAnimationController.forward())
          .thenAnswer((invocation) => TickerFuture.complete());
      when(() => exitAnimationController.reverse())
          .thenAnswer((invocation) => TickerFuture.complete());
      when(() => exitAnimationController.addStatusListener(any()))
          .thenAnswer((invocation) {});
      when(() => exitAnimationController.dispose()).thenAnswer((invocation) {});
    });

    testWidgets(
        'calls enterAnimationController forward '
        'when status is in forwardEnterStatuses', (tester) async {
      final streamController = StreamController<HomeState>();
      whenListen(
        homeBloc,
        streamController.stream,
        initialState: HomeState(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: SampleWidget(
            mockedEnterTransitionController: enterAnimationController,
            mockedExitTransitionController: exitAnimationController,
          ),
        ),
      );

      streamController.add(const HomeState());
      verify(() => enterAnimationController.forward()).called(1);
    });

    testWidgets(
        'calls exitAnimationController forward '
        'when status is in forwardExitStatuses', (tester) async {
      final streamController = StreamController<HomeState>();
      whenListen(
        homeBloc,
        streamController.stream,
        initialState: HomeState(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: SampleWidget(
            mockedEnterTransitionController: enterAnimationController,
            mockedExitTransitionController: exitAnimationController,
          ),
        ),
      );

      streamController
          .add(const HomeState(status: Status.welcomeToAskQuestion));
      verify(() => exitAnimationController.forward()).called(1);
    });

    testWidgets(
        'calls exitAnimationController reverse '
        'when status is in backEnterStatuses', (tester) async {
      final streamController = StreamController<HomeState>();
      whenListen(
        homeBloc,
        streamController.stream,
        initialState: HomeState(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: SampleWidget(
            mockedEnterTransitionController: enterAnimationController,
            mockedExitTransitionController: exitAnimationController,
          ),
        ),
      );

      streamController.add(const HomeState(status: Status.askQuestion));
      verify(() => exitAnimationController.reverse()).called(1);
    });

    testWidgets(
        'calls enterAnimationController reverse '
        'when status is in backExitStatuses', (tester) async {
      final streamController = StreamController<HomeState>();
      whenListen(
        homeBloc,
        streamController.stream,
        initialState: HomeState(),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: SampleWidget(
            mockedEnterTransitionController: enterAnimationController,
            mockedExitTransitionController: exitAnimationController,
          ),
        ),
      );

      streamController
          .add(const HomeState(status: Status.askQuestionToThinking));

      await tester.pumpAndSettle();
      verify(() => enterAnimationController.reverse()).called(1);
    });
  });
}
