// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

void main() {
  group('ApiClient', () {
    test('can be instantiated', () {
      expect(ApiClient(), isNotNull);
    });
  });
}
