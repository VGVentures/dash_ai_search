import 'package:flutter/material.dart';

/// {@template vertex_text_styles}
/// App Text Style Definitions
/// {@endtemplate}
class VertexTextStyles {
  /// {@macro vertex_text_styles}

  static TextStyle get _baseTextStyle => const TextStyle(
        fontWeight: FontWeight.w400,
        package: 'app_ui',
        fontFamily: 'OpenSans',
        color: Colors.black,
      );

  /// Title Style
  static TextStyle get display => _baseTextStyle.copyWith(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        height: 1.11,
        letterSpacing: -2,
      );

  /// Button Style
  static TextStyle get body => _baseTextStyle.copyWith(
        fontSize: 18,
        height: 1.3,
        letterSpacing: -0.5,
      );

  /// Label Style
  static TextStyle get label => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        height: 1.7,
        letterSpacing: 2,
      );
}
