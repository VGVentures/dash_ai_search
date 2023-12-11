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
        () => apiClient.post(
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);
    });

    group('getVertexResponse', () {
      group('realApiEnabled=true', () {
        test('returns a VertexResponse if success', () async {
          when(() => response.statusCode).thenReturn(200);
          final vertexResponse = VertexResponse(
            summary: '',
            documents: const [
              VertexDocument(
                metadata: VertexMetadata(url: '', title: '', description: ''),
                id: '',
              ),
            ],
          );
          when(() => response.body).thenReturn(
            jsonEncode(vertexResponse.toJson()),
          );
          final result =
              await questionsResourceApiEnabled.getVertexResponse('');
          expect(result, equals(vertexResponse));
        });

        test('throws ApiClientError when request fails', () async {
          when(() => response.statusCode).thenReturn(500);
          when(() => response.body).thenReturn('Ops');
          await expectLater(
            questionsResourceApiEnabled.getVertexResponse(''),
            throwsA(isA<ApiClientError>()),
          );
        });

        test('throws ApiClientError when request success but wrong body',
            () async {
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('Ops');
          await expectLater(
            questionsResourceApiEnabled.getVertexResponse(''),
            throwsA(isA<ApiClientError>()),
          );
        });
      });

      group('realApiEnabled=false', () {
        test('returns a VertexResponse', () async {
          final result =
              await questionsResourceApiNotEnabled.getVertexResponse('');
          expect(result, isA<VertexResponse>());
        });
      });
    });
  });
}
