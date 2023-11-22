import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('QuestionsResource', () {
    late ApiClient apiClient;
    late QuestionsResource questionsResourceApiEnabled;
    late QuestionsResource questionsResourceApiNotEnabled;
    late http.Response response;

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();
      questionsResourceApiEnabled =
          QuestionsResource(apiClient: apiClient, realApiEnabled: true);
      questionsResourceApiNotEnabled = QuestionsResource(apiClient: apiClient);
      when(
        () => apiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => response);
    });

    group('getVertexResponse', () {
      test('returns a VertexResponse for api enabled', () async {
        when(() => response.statusCode).thenReturn(200);
        final vertexResponse = VertexResponse(
          summary: '',
          documents: const [
            VertexDocument(
              metadata: VertexMetadata(url: '', title: '', description: ''),
            ),
          ],
        );
        when(() => response.body).thenReturn(
          jsonEncode(vertexResponse.toJson()),
        );
        final result = await questionsResourceApiEnabled.getVertexResponse('');
        expect(result, equals(vertexResponse));
      });

      test('returns a VertexResponse for api disabled', () async {
        final result =
            await questionsResourceApiNotEnabled.getVertexResponse('');
        expect(result, isA<VertexResponse>());
      });
    });
  });
}
