import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/home/home.dart';
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
    late final DashAnimations dashAnimations;

    setUpAll(() async {
      dashAnimations = DashAnimations();
      await dashAnimations.load();
    });

    setUp(() {
      homeBloc = _MockHomeBloc();

      whenListen(
        homeBloc,
        Stream.fromIterable(const <HomeState>[]),
        initialState: const HomeState(),
      );
    });

    Widget bootstrap([PhasedState<DashAnimationPhase>? animationState]) =>
        RepositoryProvider.value(
          value: dashAnimations,
          child: BlocProvider.value(
            value: homeBloc,
            child: DashAnimationContainer(
              animationState: animationState,
            ),
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
    late HomeBloc bloc;
    late final DashAnimations dashAnimations;

    setUpAll(() async {
      dashAnimations = DashAnimations();
      await dashAnimations.load();
    });

    setUp(() {
      bloc = _MockHomeBloc();
      whenListen(
        bloc,
        Stream.fromIterable(const <HomeState>[]),
        initialState: const HomeState(),
      );
    });

    Widget bootstrap() => RepositoryProvider.value(
          value: dashAnimations,
          child: BlocProvider.value(
            value: bloc,
            child: Material(
              child: DashSpriteAnimation(
                width: 100,
                height: 100,
              ),
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

      final image = dashAnimations.images.fromCache('dash_wave_animation.png');

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

        final image =
            dashAnimations.images.fromCache('dash_idle_animation.png');
        final currentAnimaton = tester.widget<InternalSpriteAnimationWidget>(
          find.byType(InternalSpriteAnimationWidget),
        );

        expect(
          currentAnimaton.animation.frames.first.sprite.image,
          equals(image),
        );
      },
    );

    testWidgets(
      'plays the thumbs up when there is a good answer feedback',
      (tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          bloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());
        await tester.pump();

        final spriteAnimationWidget = tester.widget<SpriteAnimationWidget>(
          find.byType(SpriteAnimationWidget),
        );

        spriteAnimationWidget.onComplete!();

        await tester.pump();

        controller.add(
          const HomeState(
            answerFeedback: AnswerFeedback.good,
          ),
        );

        await tester.pump();

        final image =
            dashAnimations.images.fromCache('dash_happy_animation.png');
        final currentAnimaton = tester.widget<InternalSpriteAnimationWidget>(
          find.byType(InternalSpriteAnimationWidget),
        );

        expect(
          currentAnimaton.animation.frames.first.sprite.image,
          equals(image),
        );
      },
    );

    testWidgets(
      'plays the thumbs down when there is a bad answer feedback',
      (tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          bloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());
        await tester.pump();

        final spriteAnimationWidget = tester.widget<SpriteAnimationWidget>(
          find.byType(SpriteAnimationWidget),
        );

        spriteAnimationWidget.onComplete!();

        await tester.pump();

        controller.add(
          const HomeState(
            answerFeedback: AnswerFeedback.bad,
          ),
        );

        await tester.pump();

        final image = dashAnimations.images.fromCache('dash_sad_animation.png');
        final currentAnimaton = tester.widget<InternalSpriteAnimationWidget>(
          find.byType(InternalSpriteAnimationWidget),
        );

        expect(
          currentAnimaton.animation.frames.first.sprite.image,
          equals(image),
        );
      },
    );

    testWidgets(
      'returns to idle when the reaction is over',
      (tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          bloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());
        await tester.pump();

        var spriteAnimationWidget = tester.widget<SpriteAnimationWidget>(
          find.byType(SpriteAnimationWidget),
        );

        spriteAnimationWidget.onComplete!();

        await tester.pump();

        controller.add(
          const HomeState(
            answerFeedback: AnswerFeedback.bad,
          ),
        );

        await tester.pump();

        spriteAnimationWidget = tester.widget<SpriteAnimationWidget>(
          find.byType(SpriteAnimationWidget),
        );

        spriteAnimationWidget.onComplete!();

        await tester.pump();

        final image =
            dashAnimations.images.fromCache('dash_idle_animation.png');
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
