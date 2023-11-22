import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VertexTheme themeData', () {
    test('is defined for standard', () {
      expect(VertexTheme.standard, isA<ThemeData>());
    });
  });
}
