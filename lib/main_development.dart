import 'package:api_client/api_client.dart';
import 'package:dash_ai_search/app/app.dart';
import 'package:dash_ai_search/bootstrap.dart';

void main() {
  bootstrap(
    () {
      final apiClient = ApiClient(
        baseUrl: 'http://localhost:8080',
        idTokenStream: const Stream.empty(),
        refreshIdToken: () async => Future.value(),
      );

      return App(
        apiClient: apiClient,
      );
    },
  );
}
