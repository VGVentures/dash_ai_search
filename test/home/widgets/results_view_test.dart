import 'dart:async';

import 'package:api_client/api_client.dart';
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
  group('ResultsView', () {
    late HomeBloc homeBloc;
    const response = VertexResponse(
      summary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
          'sed do eiusmod tempor incididunt ut labore et dolore magna '
          'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
          'ullamco laboris nisi ut aliquip ex ea commodo consequat. '
          'Duis aute irure dolor in reprehenderit in voluptate velit '
          'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
          'occaecat cupidatat non proident, sunt in culpa qui officia'
          ' deserunt mollit anim id est laborum.',
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

    testWidgets('renders the response summary', (tester) async {
      await tester.pumpApp(bootstrap());
      expect(find.text(response.summary), findsOneWidget);
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

    testWidgets(
      'calls Results on enter',
      (WidgetTester tester) async {
        await tester.pumpApp(bootstrap());
        await tester.pumpAndSettle();
        verify(() => homeBloc.add(Results())).called(1);
      },
    );

    testWidgets(
      'calls SeeResultsSourceAnswers on exit',
      (WidgetTester tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          homeBloc,
          controller.stream,
          initialState: const HomeState(),
        );

        await tester.pumpApp(bootstrap());
        await tester.pumpAndSettle();

        controller.add(const HomeState(status: Status.resultsToSourceAnswers));
        await tester.pumpAndSettle();

        verify(() => homeBloc.add(SeeResultsSourceAnswers())).called(1);
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

      final forwardEnterStatuses = tester
          .state<CarouselViewState>(find.byType(CarouselView))
          .forwardEnterStatuses;

      expect(forwardEnterStatuses, equals([Status.resultsToSourceAnswers]));
    });

    testWidgets(
        'calls SeeSourceAnswersRequested on SeeSourceAnswersButton tapped',
        (tester) async {
      await tester.pumpApp(bootstrap());

      await tester.pumpAndSettle();
      await tester.tap(find.byType(SeeSourceAnswersButton));

      verify(() => homeBloc.add(const SeeSourceAnswersRequested())).called(1);
    });

    testWidgets('adds AnswerFeedback.good on thumbs up', (tester) async {
      await tester.pumpApp(bootstrap());

      await tester.pumpAndSettle();
      await tester.tap(find.byType(CircleAvatar).first);

      verify(
        () => homeBloc.add(
          const AnswerFeedbackUpdated(AnswerFeedback.good),
        ),
      ).called(1);
    });

    testWidgets('adds AnswerFeedback.bad on thumbs down', (tester) async {
      await tester.pumpApp(bootstrap());

      await tester.pumpAndSettle();
      await tester.tap(find.byType(CircleAvatar).last);

      verify(
        () => homeBloc.add(
          const AnswerFeedbackUpdated(AnswerFeedback.bad),
        ),
      ).called(1);
    });
  });
}
