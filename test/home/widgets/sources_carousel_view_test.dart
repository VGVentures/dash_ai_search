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
      'calls NavigateSourceAnswers taps on next button',
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
        final finder = find.byType(TextButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
        verify(() => homeBloc.add(NavigateSourceAnswers('[2]'))).called(1);
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
