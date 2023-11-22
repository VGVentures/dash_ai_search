import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/generated/assets.gen.dart';
import 'package:flutter/material.dart';

/// {@template cta_button}
/// A button that displays an image on the left side and a text on the right
/// side.
/// {@endtemplate}
class CTAButton extends StatelessWidget {
  /// {@macro cta_button}
  const CTAButton({
    required this.label,
    this.icon,
    this.onPressed,
    super.key,
  });

  /// The image that will be displayed on the left side of the button.
  final AssetGenImage? icon;

  /// The text that will be displayed on the right side of the button.
  final String label;

  /// The callback that will be called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          VertexColors.googleBlue,
        ),
        padding: MaterialStatePropertyAll(
          EdgeInsets.only(
            left: 8,
            top: 8,
            bottom: 8,
            right: 32,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(48),
                  color: VertexColors.white,
                ),
                child: icon!.image(color: VertexColors.googleBlue),
              ),
            if (icon != null) const SizedBox(width: 12),
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
      ),
    );
  }
}
