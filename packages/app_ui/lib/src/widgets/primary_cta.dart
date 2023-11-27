import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template primary_cta}
/// A button that displays an image on the left side and a text on the right
/// side.
/// {@endtemplate}
class PrimaryCTA extends StatelessWidget {
  /// {@macro primary_cta}
  const PrimaryCTA({
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(
          VertexColors.googleBlue,
        ),
        padding: MaterialStatePropertyAll(
          EdgeInsets.only(
            left: icon != null ? 24 : 32,
            top: 20,
            bottom: 20,
            right: 32,
          ),
        ),
      ),
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