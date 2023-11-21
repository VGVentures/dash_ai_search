import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('VertexResponse', () {
    test('supports equality', () {
      expect(
        VertexResponse(
          summary: '',
          documents: const [
            VertexDocument(
              metadata: VertexMetadata(url: '', title: '', description: ''),
            ),
          ],
        ),
        equals(
          VertexResponse(
            summary: '',
            documents: const [
              VertexDocument(
                metadata: VertexMetadata(url: '', title: '', description: ''),
              ),
            ],
          ),
        ),
      );
    });
  });
}
