import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/typography/vertex_text_styles.dart';
import 'package:flutter/material.dart';

/// {@template vertex_theme}
/// The default [ThemeData].
/// {@endtemplate}
class VertexTheme {
  /// Standard `ThemeData` for VertexAI UI.
  static ThemeData get standard {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(accentColor: VertexColors.navy),
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: VertexTextStyles.display,
      bodyLarge: VertexTextStyles.body,
      labelLarge: VertexTextStyles.label,
    );
  }
}
