import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template tertiary_cta}
/// TertiaryCTA
/// side.
/// {@endtemplate}
class TertiaryCTA extends StatelessWidget {
  /// {@macro tertiary_cta}
  const TertiaryCTA({
    required this.label,
    this.icon,
    this.onPressed,
    super.key,
  });

  /// The image that will be displayed on the left side of the button.
  final Image? icon;

  /// The text that will be displayed on the right side of the button.
  final String label;

  /// The callback that will be called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: VertexColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
