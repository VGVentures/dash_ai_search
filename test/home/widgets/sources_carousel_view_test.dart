import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SourcesCarouselView', () {
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

    testWidgets(
      'renders N AnimatedBox',
      (WidgetTester tester) async {
        await tester.pumpApp(
          SourcesCarouselView(
            documents: documents,
          ),
        );
        expect(find.byType(AnimatedBox), findsNWidgets(4));
      },
    );

    testWidgets(
      'taps on next updates the counter',
      (WidgetTester tester) async {
        await tester.pumpApp(
          SourcesCarouselView(
            documents: documents,
          ),
        );
        expect(find.text('1/4'), findsOneWidget);
        final finder = find.byType(TextButton);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('2/4'), findsOneWidget);
      },
    );
  });
}
