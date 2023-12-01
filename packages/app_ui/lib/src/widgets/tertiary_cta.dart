import 'package:app_ui/app_ui.dart';
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

  /// The icon that will be displayed on the left side of the button.
  final Widget? icon;

  /// The text that will be displayed on the right side of the button.
  final String label;

  /// The callback that will be called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  State<TertiaryCTA> createState() => _TertiaryCTAState();
}

class _TertiaryCTAState extends State<TertiaryCTA>
    with SingleTickerProviderStateMixin {
  final DecorationTween decorationTween = DecorationTween(
    begin: const BoxDecoration(),
    end: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: VertexColors.white, width: 2),
      ),
    ),
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: const ButtonStyle(
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
      ),
      onHover: (hovered) {
        if (hovered) {
          _controller.forward(from: 0);
        } else {
          _controller.reverse(from: 1);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SizedBox.square(
                dimension: 24,
                child: widget.icon,
              ),
            ),
          Flexible(
            child: DecoratedBoxTransition(
              decoration: decorationTween.animate(_controller),
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
