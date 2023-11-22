import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('VertexMetadata', () {
    test('supports equality', () {
      expect(
        VertexMetadata(url: '', title: '', description: ''),
        equals(
          VertexMetadata(url: '', title: '', description: ''),
        ),
      );
    });
  });
}
