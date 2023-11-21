import 'package:api_client/api_client.dart';

Future<void> main() async {
  final apiClient = ApiClient(
    baseUrl: 'http://development',
    idTokenStream: const Stream.empty(),
    refreshIdToken: () async => Future.value(),
  );
  final questionsResource = apiClient.questionsResource;
  final answer = await questionsResource.getVertexResponse('random');
  // ignore: avoid_print
  print(answer);
}
