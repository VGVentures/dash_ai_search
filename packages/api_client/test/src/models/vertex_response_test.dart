import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('VertexResponse', () {
    test('empty constructor', () {
      expect(
        VertexResponse.empty(),
        equals(VertexResponse(summary: '', documents: const [])),
      );
    });

    test('supports equality', () {
      expect(
        VertexResponse(
          summary: '',
          documents: const [
            VertexDocument(
              metadata: VertexMetadata(url: '', title: '', description: ''),
              id: '',
            ),
          ],
        ),
        equals(
          VertexResponse(
            summary: '',
            documents: const [
              VertexDocument(
                metadata: VertexMetadata(url: '', title: '', description: ''),
                id: '',
              ),
            ],
          ),
        ),
      );
    });
  });
}
