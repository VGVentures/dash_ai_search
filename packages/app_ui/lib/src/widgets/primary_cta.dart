import 'package:flutter/material.dart';

/// {@template primary_cta}
/// PrimaryCTA
/// {@endtemplate}
class PrimaryCTA extends StatelessWidget {
  /// {@macro primary_cta}
  const PrimaryCTA({
    required this.label,
    this.onPressed,
    super.key,
  });

  /// The text that will be displayed on the right side of the button.
  final String label;

  /// The callback that will be called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          left: 32,
          top: 20,
          bottom: 20,
          right: 32,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
