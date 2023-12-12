import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/results/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

void main() {
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
      'adds HomeSourceAnswersNavigated tapping on the link if state '
      'Status.seeSourceAnswers',
      (WidgetTester tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(vertexResponse: response, status: Status.seeSourceAnswers),
        );
        await tester.pumpApp(bootstrap());
        final widget = tester.widget<InkWell>(find.byType(InkWell).first);
        widget.onTap?.call();
        verify(() => homeBloc.add(HomeSourceAnswersNavigated('[1]'))).called(1);
      },
    );

    testWidgets(
      'adds HomeSeeSourceAnswersRequested tapping on the link if state '
      'is not Status.seeSourceAnswers',
      (WidgetTester tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(vertexResponse: response, status: Status.results),
        );
        await tester.pumpApp(bootstrap());
        final widget = tester.widget<InkWell>(find.byType(InkWell).first);
        widget.onTap?.call();
        verify(() => homeBloc.add(HomeSeeSourceAnswersRequested('[1]')))
            .called(1);
      },
    );
  });
}
