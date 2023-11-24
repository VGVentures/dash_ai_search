import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questions_repository/questions_repository.dart';
import 'package:test/test.dart';

class _MockQuestionsResource extends Mock implements QuestionsResource {}

class _FakeVertexResponse extends Fake implements VertexResponse {}

void main() {
  group('QuestionsRepository', () {
    late QuestionsResource questionsResource;
    late QuestionsRepository questionsRepository;

    setUp(() {
      questionsResource = _MockQuestionsResource();
      questionsRepository = QuestionsRepository(questionsResource);
    });

    setUpAll(() {
      registerFallbackValue(_FakeVertexResponse());
    });

    group('getVertexResponse', () {
      test('returns VertexResponse', () {
        when(() => questionsResource.getVertexResponse(any()))
            .thenAnswer((_) async => _FakeVertexResponse());
        expectLater(
          questionsRepository.getVertexResponse(''),
          completion(isA<VertexResponse>()),
        );
      });
    });
  });
}
