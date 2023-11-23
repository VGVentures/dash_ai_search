import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    test('states can be instantiated', () {
      expect(HomeState(status: Status.welcome), isNotNull);
    });

    group('copyWith', () {
      test('returns same HomeState object when no properties', () {
        expect(
          HomeState.initial().copyWith(),
          HomeState.initial(),
        );
      });

      test('returns object with updated status when all parameters are passed',
          () {
        expect(
          HomeState.initial().copyWith(status: Status.welcome),
          HomeState(status: Status.welcome),
        );
      });
    });
  });
}
