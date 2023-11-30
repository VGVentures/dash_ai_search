import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
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

  group('DashSpriteAnimation', () {
    final images = Images(prefix: 'assets/animations/');
    late HomeBloc bloc;

    setUpAll(() async {
      await Future.wait([
        images.load('dash_idle_animation.png'),
        images.load('dash_wave_animation.png'),
        images.load('dash_happy_animation.png'),
        images.load('dash_sad_animation.png'),
      ]);
    });

    setUp(() {
      bloc = _MockHomeBloc();
      whenListen(
        bloc,
        Stream.fromIterable(const <HomeState>[]),
        initialState: const HomeState(),
      );
    });

    Widget bootstrap() => BlocProvider.value(
          value: bloc,
          child: Material(
            child: DashSpriteAnimation(
              width: 100,
              height: 100,
              images: images,
            ),
          ),
        );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(bootstrap());
      await tester.pump();

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });

    testWidgets('starts with the waving animation', (tester) async {
      await tester.pumpApp(bootstrap());
      await tester.pump();

      final image = images.fromCache('dash_wave_animation.png');

      final currentAnimaton = tester.widget<InternalSpriteAnimationWidget>(
        find.byType(InternalSpriteAnimationWidget),
      );

      expect(
        currentAnimaton.animation.frames.first.sprite.image,
        equals(image),
      );
    });

    testWidgets(
      'changes to idle animation when the waving is finished',
      (tester) async {
        await tester.pumpApp(bootstrap());
        await tester.pump();

        final spriteAnimationWidget = tester.widget<SpriteAnimationWidget>(
          find.byType(SpriteAnimationWidget),
        );

        spriteAnimationWidget.onComplete!();

        await tester.pump();

        final image = images.fromCache('dash_idle_animation.png');
        final currentAnimaton = tester.widget<InternalSpriteAnimationWidget>(
          find.byType(InternalSpriteAnimationWidget),
        );

        expect(
          currentAnimaton.animation.frames.first.sprite.image,
          equals(image),
        );
      },
    );
  });
}
