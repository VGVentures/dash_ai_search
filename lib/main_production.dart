import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/bootstrap.dart';
import 'package:questions_repository/questions_repository.dart';

void main() async {
  await bootstrap(
    () async {
      final apiClient = ApiClient(
        baseUrl: 'http://production',
      );

      final questionsRepository =
          QuestionsRepository(apiClient.questionsResource);

      final dashAnimations = DashAnimations();
      await dashAnimations.load();

      return App(
        questionsRepository: questionsRepository,
        dashAnimations: dashAnimations,
      );
    },
  );
}
