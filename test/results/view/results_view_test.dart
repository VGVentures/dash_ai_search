import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:dash_ai_search/question/question.dart';
import 'package:dash_ai_search/results/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
  group('ResultsView', () {
    late HomeBloc homeBloc;
    const response = VertexResponse(
      summary: 'Flutter is a free and open source software development '
          "kit (SDK) from Google [1]. It's used to create beautiful, "
          'fast user experiences, ,,,for mobile, web, and desktop '
          'applications [1]. Flutter works with existing code and is used '
          'by developers and organizations around the world [1]. [3]. '
          'Flutter is a fully open source project [3].',
      documents: [
        VertexDocument(
          id: '1',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '2',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '3',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
        VertexDocument(
          id: '4',
          metadata: VertexMetadata(
            url: 'url',
            title: 'title',
            description: 'description',
          ),
        ),
      ],
    );

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(
        HomeState(vertexResponse: response),
      );
    });

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(child: ResultsView()),
        );

    testWidgets('renders SummaryView', (tester) async {
      await tester.pumpApp(bootstrap());
      expect(find.byType(SummaryView), findsOneWidget);
    });

    testWidgets('renders SearchBox', (tester) async {
      await tester.pumpApp(bootstrap());
      expect(find.byType(SearchBox), findsOneWidget);
    });

    testWidgets('renders CarouselView', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(vertexResponse: response, status: Status.seeSourceAnswers),
      );
      await tester.pumpApp(bootstrap());
      expect(find.byType(CarouselView), findsOneWidget);
    });

    testWidgets('calls HomeBackToAiSummaryTapped on backToAiResults tapped',
        (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(vertexResponse: response, status: Status.seeSourceAnswers),
      );
      await tester.pumpApp(bootstrap());

      final button =
          tester.widget<TertiaryCTA>(find.byKey(Key('backToAnswerButtonKey')));
      button.onPressed!();
      verify(() => homeBloc.add(const HomeBackToAiSummaryTapped())).called(1);
    });

    testWidgets('animates in search box when enter', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardEnterStatuses = tester
          .state<SearchBoxViewState>(find.byType(SearchBoxView))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.thinkingToResults]));
    });

    testWidgets('animates in BlueContainer when enter', (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardEnterStatuses = tester
          .state<BlueContainerState>(find.byType(BlueContainer))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.thinkingToResults]));
    });

    testWidgets('animates out BlueContainer when exits forward',
        (tester) async {
      await tester.pumpApp(bootstrap());

      final forwardExitStatuses = tester
          .state<BlueContainerState>(find.byType(BlueContainer))
          .forwardExitStatuses;

      expect(forwardExitStatuses, equals([Status.resultsToSourceAnswers]));
    });

    testWidgets('BlueContainer resize itself', (tester) async {
      await tester.pumpApp(bootstrap());

      var state = tester.state<BlueContainerState>(find.byType(BlueContainer));

      final originalSizeIn = state.sizeIn;

      tester.setViewSize(size: Size(2000, 1000));
      await tester.pump();

      state = tester.state<BlueContainerState>(find.byType(BlueContainer));

      final sizeIn = state.sizeIn;
      expect(sizeIn, isNot(equals(originalSizeIn)));
    });

    testWidgets(
      'calls HomeNavigated(seeSourceAnswers) on exit',
      (WidgetTester tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(vertexResponse: response),
        );

        await tester.pumpApp(bootstrap());
        await tester.pumpAndSettle();

        controller.add(
          const HomeState(
            vertexResponse: response,
            status: Status.resultsToSourceAnswers,
          ),
        );
        await tester.pumpAndSettle();

        verify(() => homeBloc.add(HomeNavigated(Status.seeSourceAnswers)))
            .called(1);
      },
    );

    testWidgets(
      'calls Results on back exit',
      (WidgetTester tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(
            vertexResponse: response,
          ),
        );

        await tester.pumpApp(bootstrap());
        await tester.pumpAndSettle();

        controller.add(
          const HomeState(
            vertexResponse: response,
            status: Status.resultsToSourceAnswers,
          ),
        );

        await tester.pumpAndSettle();

        controller.add(
          const HomeState(
            vertexResponse: response,
            status: Status.sourceAnswersBackToResults,
          ),
        );
        await tester.pumpAndSettle();

        verify(() => homeBloc.add(HomeNavigated(Status.results))).called(2);
      },
    );

    testWidgets('animates in CarouselView when enter', (tester) async {
      when(() => homeBloc.state).thenReturn(
        HomeState(
          vertexResponse: response,
          status: Status.seeSourceAnswers,
        ),
      );

      await tester.pumpApp(bootstrap());

      final carouselViewState =
          tester.state<CarouselViewState>(find.byType(CarouselView));

      expect(
        carouselViewState.forwardEnterStatuses,
        equals([Status.resultsToSourceAnswers]),
      );
      expect(
        carouselViewState.backExitStatuses,
        equals([Status.sourceAnswersBackToResults]),
      );
    });

    testWidgets(
        'calls HomeSeeSourceAnswersRequested on SeeSourceAnswersButton tapped',
        (tester) async {
      await tester.pumpApp(bootstrap());

      final l10n = tester.element(find.byType(ResultsView)).l10n;

      await tester.pump();
      tester
          .widget<TertiaryCTA>(
            find.ancestor(
              of: find.text(l10n.seeSourceAnswers),
              matching: find.byType(TertiaryCTA),
            ),
          )
          .onPressed
          ?.call();

      verify(() => homeBloc.add(const HomeSeeSourceAnswersRequested(null)))
          .called(1);
    });

    testWidgets('adds AnswerFeedback.good on thumbs up', (tester) async {
      await tester.pumpApp(bootstrap());

      await tester.pump();
      tester
          .widget<FeedbackButtons>(find.byType(FeedbackButtons))
          .onLike
          ?.call();

      verify(
        () => homeBloc.add(
          const HomeAnswerFeedbackAdded(AnswerFeedback.good),
        ),
      ).called(1);
    });

    testWidgets('adds AnswerFeedback.bad on thumbs down', (tester) async {
      await tester.pumpApp(bootstrap());

      await tester.pump();
      tester
          .widget<FeedbackButtons>(find.byType(FeedbackButtons))
          .onDislike
          ?.call();

      verify(
        () => homeBloc.add(
          const HomeAnswerFeedbackAdded(AnswerFeedback.bad),
        ),
      ).called(1);
    });
  });
}
