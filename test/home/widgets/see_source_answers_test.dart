import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/see_source_answers.dart';
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
      summary: 'summary',
      documents: [
        VertexDocument(
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
        HomeState(status: Status.seeSourceAnswers, vertexResponse: response),
      );
    });

    testWidgets('renders the response', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: homeBloc,
          child: Material(child: SeeSourceAnswers()),
        ),
      );
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.text(response.summary), findsOneWidget);
      expect(find.text(response.documents.length.toString()), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.byType(FeedbackButtons), findsOneWidget);
    });
  });
}
