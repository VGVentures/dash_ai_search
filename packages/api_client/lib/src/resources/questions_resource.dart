import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:api_client/src/resources/fake_response.dart';

/// {@template questions_resource}
/// An api resource to get response to question from the VERTEX api
/// {@endtemplate}
class QuestionsResource {
  /// {@macro questions_resource}
  const QuestionsResource({
    required ApiClient apiClient,
    bool realApiEnabled = false,
  })  : _apiClient = apiClient,
        _realApiEnabled = realApiEnabled;

  final ApiClient _apiClient;
  final bool _realApiEnabled;

  /// Returns [VertexResponse] based on a query.
  ///
  Future<VertexResponse> getVertexResponse(String query) async {
    String body;
    if (_realApiEnabled) {
      final response = await _apiClient.post(
        body: jsonEncode(
          {
            'search_term': query,
          },
        ),
      );
      if (response.statusCode != 200) {
        throw ApiClientError(
          'POST getVertexResponse with query=$query '
          'returned status ${response.statusCode} '
          'with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
      body = response.body;
    } else {
      await Future<void>.delayed(const Duration(seconds: 2));

      body = switch (query) {
        'What is flutter?' => FakeResponses.whatIsFlutterResponse,
        'What platforms does flutter support today?' =>
          FakeResponses.platformsResponse,
        'What language do you use to write flutter apps?' =>
          FakeResponses.languageResponse,
        'How does hot reload work in flutter?' =>
          FakeResponses.hotReloadResponse,
        _ => FakeResponses.invalidResponse,
      };
    }

    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return VertexResponse.fromJson(json);
    } catch (e) {
      throw ApiClientError(
        'GET getVertexResponse with query=$query '
        'returned invalid response "$body"',
        StackTrace.current,
      );
    }
  }
}
