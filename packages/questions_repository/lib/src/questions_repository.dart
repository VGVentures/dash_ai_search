import 'package:api_client/api_client.dart';

/// {@template questions_repository}
/// Repository to access QuestionsResource from the Api Client.
/// {@endtemplate}
class QuestionsRepository {
  /// {@macro questions_repository}
  const QuestionsRepository(this._questionsResource);

  final QuestionsResource _questionsResource;

  /// Returns [VertexResponse] based on a query.
  Future<VertexResponse> getVertexResponse(String query) async {
    return _questionsResource.getVertexResponse(query);
  }
}
