import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:cross_file/cross_file.dart';

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
      final response = await _apiClient.get(
        // TODO(oscar): update with real API once is enabled
        // and add possible failures.
        'google.es',
        queryParameters: {
          'query': query,
        },
      );
      if (response.statusCode != 200) {
        throw ApiClientError(
          'GET getVertexResponse with query=$query '
          'returned status ${response.statusCode} '
          'with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
      body = response.body;
    } else {
      const path = 'lib/src/resources/fake_response.json';
      body = await XFile(path).readAsString();
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
