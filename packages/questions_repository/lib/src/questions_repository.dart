import 'package:api_client/api_client.dart';

/// {@template questions_repository}
/// A Very Good Project created by Very Good CLI.
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
