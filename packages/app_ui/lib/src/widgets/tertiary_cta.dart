import 'package:flutter/material.dart';

/// {@template tertiary_cta}
/// TertiaryCTA
/// {@endtemplate}
class TertiaryCTA extends StatefulWidget {
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
  State<TertiaryCTA> createState() => _TertiaryCTAState();
}

class _TertiaryCTAState extends State<TertiaryCTA> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: const ButtonStyle(
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
      ),
      onHover: (newHovered) {
        setState(() {
          hovered = newHovered;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: widget.icon,
            ),
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: hovered
                    ? const Border(
                        bottom: BorderSide(color: Colors.white, width: 2),
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
