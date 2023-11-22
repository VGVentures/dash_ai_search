import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('QuestionsResource', () {
    test('returns a VertexResponse', () async {
      const questionsResource = QuestionsResource();
      final response = await questionsResource.getVertexResponse('');
      expect(response, isA<VertexResponse>());
    });
  });
}
