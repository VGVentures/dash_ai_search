// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:authentication_repository/authentication_repository.dart';

void main() {
  group('AuthenticationRepository', () {
    test('can be instantiated', () {
      expect(AuthenticationRepository(), isNotNull);
    });
  });
}
