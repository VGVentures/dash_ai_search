import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('VertexDocument', () {
    test('supports equality', () {
      expect(
        VertexDocument(
          metadata: VertexMetadata(url: '', title: '', description: ''),
          id: '',
        ),
        equals(
          VertexDocument(
            metadata: VertexMetadata(url: '', title: '', description: ''),
            id: '',
          ),
        ),
      );
    });
  });
}
