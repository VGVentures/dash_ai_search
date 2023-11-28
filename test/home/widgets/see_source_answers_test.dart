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
  group('SeeSourceAnswers', () {
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

    testWidgets('renders the response summary', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: Material(child: SeeSourceAnswers()),
        ),
      );
      expect(find.text(response.summary), findsOneWidget);
    });

    testWidgets('renders SearchBox', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: Material(child: SeeSourceAnswers()),
        ),
      );
      expect(find.byType(SearchBox), findsOneWidget);
    });

    testWidgets('renders SourcesCarouselView', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: Material(child: SeeSourceAnswers()),
        ),
      );
      expect(find.byType(SourcesCarouselView), findsOneWidget);
    });
  });
}
