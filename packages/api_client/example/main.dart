import 'package:api_client/api_client.dart';

Future<void> main() async {
  final apiClient = ApiClient(
    baseUrl: '',
  );
  final questionsResource = apiClient.questionsResource;
  final answer = await questionsResource.getVertexResponse('random');
  // ignore: avoid_print
  print(answer);
}
