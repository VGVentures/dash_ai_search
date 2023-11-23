import 'package:dash_ai_search/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    test('states can be instantiated', () {
      expect(HomeState(), isNotNull);
    });

    group('copyWith', () {
      test('returns same HomeState object when no properties', () {
        expect(
          HomeState().copyWith(),
          equals(HomeState()),
        );
      });

      test('returns object with updated status when all parameters are passed',
          () {
        expect(
          HomeState().copyWith(status: Status.askQuestion),
          equals(
            HomeState(status: Status.askQuestion),
          ),
        );
      });
    });
  });
}
