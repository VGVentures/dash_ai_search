import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VertexTextStyles', () {
    test('is defined for both display, body, and label', () {
      expect(VertexTextStyles.display, isA<TextStyle>());
      expect(VertexTextStyles.body, isA<TextStyle>());
      expect(VertexTextStyles.label, isA<TextStyle>());
    });
  });
}
