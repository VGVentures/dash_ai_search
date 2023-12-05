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
  group('SourcesCarouselView', () {
    late HomeBloc homeBloc;
    const documents = [
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
    ];

    setUp(() {
      homeBloc = _MockHomeBloc();
      when(() => homeBloc.state).thenReturn(HomeState());
    });

    testWidgets(
      'renders N AnimatedBox',
      (WidgetTester tester) async {
        await tester.pumpApp(
          SourcesCarouselView(
            documents: documents,
            previouslySelectedIndex: 0,
          ),
        );
        expect(find.byType(AnimatedBox), findsNWidgets(4));
      },
    );

    testWidgets(
      'calls NavigateSourceAnswers taps on GoPreviousButton',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: SourcesCarouselView(
              documents: documents,
              previouslySelectedIndex: 1,
            ),
          ),
        );
        final finder = find.byType(GoPreviousButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
        verify(() => homeBloc.add(NavigateSourceAnswers('[1]'))).called(1);
      },
    );

    testWidgets(
      'calls NavigateSourceAnswers taps on GoNextButton',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: SourcesCarouselView(
              documents: documents,
              previouslySelectedIndex: 0,
            ),
          ),
        );
        final finder = find.byType(GoNextButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
        verify(() => homeBloc.add(NavigateSourceAnswers('[2]'))).called(1);
      },
    );

    testWidgets(
      'navigates if previouslySelectedIndex is not 0',
      (WidgetTester tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: homeBloc,
            child: SourcesCarouselView(
              documents: documents,
              previouslySelectedIndex: 1,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('2/4'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates if previouslySelectedIndex gets updated in only one direction',
      (WidgetTester tester) async {
        var index = 0;
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return BlocProvider.value(
                value: homeBloc,
                child: Stack(
                  children: [
                    SourcesCarouselView(
                      documents: documents,
                      previouslySelectedIndex: index,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Text('Click me'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('1/4'), findsOneWidget);
        final finder = find.byType(ElevatedButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('2/4'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates if previouslySelectedIndex gets updated '
      'in only both directions',
      (WidgetTester tester) async {
        var index = 2;
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return BlocProvider.value(
                value: homeBloc,
                child: Stack(
                  children: [
                    SourcesCarouselView(
                      documents: documents,
                      previouslySelectedIndex: index,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      child: Text('Click me'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        final finder = find.byType(ElevatedButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(find.text('3/4'), findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('2/4'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates back when on the firt index and previouslySelectedIndex gets '
      'updated',
      (WidgetTester tester) async {
        var index = 0;
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return BlocProvider.value(
                value: homeBloc,
                child: Stack(
                  children: [
                    SourcesCarouselView(
                      documents: documents,
                      previouslySelectedIndex: index,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          index = documents.length - 1;
                        });
                      },
                      child: Text('Click me'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        final finder = find.byType(ElevatedButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(find.text('1/4'), findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('4/4'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates forward when on the last index and previouslySelectedIndex '
      'gets updated',
      (WidgetTester tester) async {
        var index = documents.length - 1;
        await tester.pumpApp(
          StatefulBuilder(
            builder: (context, setState) {
              return BlocProvider.value(
                value: homeBloc,
                child: Stack(
                  children: [
                    SourcesCarouselView(
                      documents: documents,
                      previouslySelectedIndex: index,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Text('Click me'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        final finder = find.byType(ElevatedButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        expect(find.text('4/4'), findsOneWidget);
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('1/4'), findsOneWidget);
      },
    );
  });

  group('SourceCard', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        const SourceCard(
          document: VertexDocument(
            id: '1',
            metadata: VertexMetadata(
              url: 'url',
              title: 'title',
              description: 'description',
            ),
          ),
          index: 0,
        ),
      );

      expect(find.text('title'), findsOneWidget);
      expect(find.text('description'), findsOneWidget);
    });

    testWidgets(
      'opens the link when clicking in the link button',
      (tester) async {
        Uri? link;
        await tester.pumpApp(
          SourceCard(
            openLink: (value) async {
              link = value;
              return true;
            },
            document: VertexDocument(
              id: '1',
              metadata: VertexMetadata(
                url: 'https://url.com',
                title: 'title',
                description: 'description',
              ),
            ),
            index: 0,
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        expect(link, equals(Uri.parse('https://url.com')));
      },
    );
  });
}
