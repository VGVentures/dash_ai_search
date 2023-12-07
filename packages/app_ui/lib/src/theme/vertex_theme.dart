import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template vertex_theme}
/// The default [ThemeData].
/// {@endtemplate}
class VertexTheme {
  /// Standard `ThemeData` for VertexAI UI.
  static ThemeData get standard {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSwatch(accentColor: VertexColors.flutterNavy),
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      useMaterial3: true,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: VertexTextStyles.displayLarge,
      displayMedium: VertexTextStyles.displayMedium,
      displaySmall: VertexTextStyles.displaySmall,
      headlineLarge: VertexTextStyles.headline,
      bodyLarge: VertexTextStyles.bodyLargeBold,
      bodyMedium: VertexTextStyles.bodyLargeMedium,
      bodySmall: VertexTextStyles.bodyLargeRegular,
      labelLarge: VertexTextStyles.labelLarge,
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: VertexTextStyles.bodyLargeRegular
          .copyWith(color: VertexColors.mediumGrey),
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: VertexColors.googleBlue,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: const BorderSide(
          color: VertexColors.googleBlue,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 32),
      hoverColor: Colors.transparent,
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: _textTheme.bodyMedium,
        backgroundColor: VertexColors.googleBlue,
        foregroundColor: VertexColors.white,
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.bodyMedium,
        foregroundColor: VertexColors.white,
      ),
    );
  }
}
