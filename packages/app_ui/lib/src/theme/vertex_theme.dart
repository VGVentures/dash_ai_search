import 'package:app_ui/app_ui.dart';
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
      inputDecorationTheme: _inputDecorationTheme,
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

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: VertexTextStyles.body.copyWith(color: VertexColors.mediumGrey),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: VertexColors.googleBlue,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: VertexColors.googleBlue,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: VertexColors.googleBlue,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 32),
    );
  }
}
