import 'package:flutter/material.dart';

//// {@macro vertex_text_styles}
abstract class VertexTextStyles {
  /// Package name
  static const package = 'app_ui';

  static const TextStyle _commonStyle = TextStyle(
    fontFamily: 'Google Sans',
    package: package,
  );

  /// displayLarge Text Style
  static TextStyle displayLarge = _commonStyle.copyWith(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -2,
    fontFamily: 'Google Sans',
  );

  /// displayMedium Text Style
  static TextStyle displayMedium = _commonStyle.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.17,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// displaySmall Text Style
  static TextStyle displaySmall = _commonStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// headline Text Style
  static TextStyle headline = _commonStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -1,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeBold Text Style
  static TextStyle bodyLargeBold = _commonStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeMedium Text Style
  static TextStyle bodyLargeMedium = _commonStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// bodyLargeRegular Text Style
  static TextStyle bodyLargeRegular = _commonStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
    fontFamily: 'Google Sans',
  );

  /// buttons&CTA's Text Style
  static TextStyle cta = _commonStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: -0.5,
    fontFamily: 'Google Sans',
  );

  /// labelLarge Text Style
  static TextStyle labelLarge = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.71,
    letterSpacing: 2,
    fontFamily: 'Google Sans',
  );
}
