import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/home/view/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('App', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        App(
          apiClient: apiClient,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
