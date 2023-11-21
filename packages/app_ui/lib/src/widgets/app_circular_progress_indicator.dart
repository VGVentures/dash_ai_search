import 'package:flutter/material.dart';

/// {@template app_circular_progress_indicator}
/// Circular progress indicator
/// {@endtemplate}
class AppCircularProgressIndicator extends StatelessWidget {
  /// {@macro app_circular_progress_indicator}
  const AppCircularProgressIndicator({
    super.key,
    this.color = Colors.blue,
    this.backgroundColor = Colors.white,
    this.strokeWidth = 4.0,
  });

  /// [Color] of the progress indicator
  final Color color;

  /// [Color] for the background
  final Color? backgroundColor;

  /// Optional stroke width of the progress indicator
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
    );
  }
}
