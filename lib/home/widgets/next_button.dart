import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final Image icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: icon,
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Color(0xFF0273E6),
        ),
        padding: MaterialStatePropertyAll(
          EdgeInsets.only(
            left: 24,
            top: 20,
            bottom: 20,
            right: 32,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
