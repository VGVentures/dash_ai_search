import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('App', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          questionsRepository: apiClient,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
