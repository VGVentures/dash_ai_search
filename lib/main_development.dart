import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/bootstrap.dart';
import 'package:questions_repository/questions_repository.dart';

void main() {
  bootstrap(
    () {
      final apiClient = ApiClient(
        baseUrl: 'http://development',
      );

      final questionsRepository =
          QuestionsRepository(apiClient.questionsResource);

      return App(
        questionsRepository: questionsRepository,
      );
    },
  );
}
