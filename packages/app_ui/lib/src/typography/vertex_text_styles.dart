import 'package:flutter/material.dart';

//// {@macro vertex_text_styles}
abstract class VertexTextStyles {
  /// displayLarge Text Style
  static const TextStyle displayLarge = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -2,
    fontFamily: 'Google Sans',
  );

  /// displayMedium Text Style
  static const TextStyle displayMedium = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.17,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// displaySmall Text Style
  static const TextStyle displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// headline Text Style
  static const TextStyle headline = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeBold Text Style
  static const TextStyle bodyLargeBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeMedium Text Style
  static const TextStyle bodyLargeMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeRegular Text Style
  static const TextStyle bodyLargeRegular = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// buttons&CTA's Text Style
  static const TextStyle cta = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: -0.5,
    fontFamily: 'Google Sans',
  );

  /// labelLarge Text Style
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.71,
    letterSpacing: 2,
    fontFamily: 'Google Sans',
  );
}
