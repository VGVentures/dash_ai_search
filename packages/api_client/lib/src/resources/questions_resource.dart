import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template questions_resource}
/// An api resource to get response to question from the VERTEX api
/// {@endtemplate}
class QuestionsResource {
  /// {@macro questions_resource}
  const QuestionsResource();

  /// Get /game/prompt/terms
  ///
  /// Returns a [List<String>].
  Future<VertexResponse> getVertexResponse(String query) async {
    const path = 'lib/src/resources/fake_response.json';
    final fakeResponse = await File(path).readAsString();

    final json = jsonDecode(fakeResponse) as Map<String, dynamic>;
    return VertexResponse.fromJson(json);
  }
}
