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

      verify(() => homeBloc.add(const SeeSourceAnswersRequested(null)))
          .called(1);
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

  group('SummaryView', () {
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

    Widget bootstrap() => BlocProvider.value(
          value: homeBloc,
          child: Material(child: SummaryView()),
        );

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(
        HomeState(vertexResponse: response),
      );
    });

    testWidgets(
      'adds NavigateSourceAnswers tapping on the link if state '
      'Status.seeSourceAnswers',
      (WidgetTester tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(vertexResponse: response, status: Status.seeSourceAnswers),
        );
        await tester.pumpApp(bootstrap());
        final widget = tester.widget<InkWell>(find.byType(InkWell).first);
        widget.onTap?.call();
        verify(() => homeBloc.add(NavigateSourceAnswers('[1]'))).called(1);
      },
    );

    testWidgets(
      'adds SeeSourceAnswersRequested tapping on the link if state '
      'is not Status.seeSourceAnswers',
      (WidgetTester tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(vertexResponse: response, status: Status.results),
        );
        await tester.pumpApp(bootstrap());
        final widget = tester.widget<InkWell>(find.byType(InkWell).first);
        widget.onTap?.call();
        verify(() => homeBloc.add(SeeSourceAnswersRequested('[1]'))).called(1);
      },
    );
  });
}
