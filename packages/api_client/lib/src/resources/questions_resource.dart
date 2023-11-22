import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

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

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].
  Future<VertexResponse> getVertexResponse(String query) async {
    if (_realApiEnabled) {
      final response = await _apiClient.get(
        'google.es',
        queryParameters: {
          'query': query,
        },
      );
      final json = jsonDecode(response.body);
      return VertexResponse.fromJson(json as Map<String, dynamic>);
    } else {
      const path = 'lib/src/resources/fake_response.json';
      final fakeResponse = await File(path).readAsString();

      final json = jsonDecode(fakeResponse) as Map<String, dynamic>;
      return VertexResponse.fromJson(json);
    }
  }
}
