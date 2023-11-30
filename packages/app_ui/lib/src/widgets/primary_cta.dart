import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template primary_cta}
/// A button that displays an image on the left side and a text on the right
/// side.
/// {@endtemplate}
class PrimaryCTA extends StatefulWidget {
  /// {@macro primary_cta}
  const PrimaryCTA({
    required this.label,
    this.icon,
    this.onPressed,
    super.key,
  });

  /// The widget that will be displayed on the left side of the button.
  final Widget? icon;

  /// The text that will be displayed on the right side of the button.
  final String label;

  /// The callback that will be called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  State<PrimaryCTA> createState() => _PrimaryCTAState();
}

class _PrimaryCTAState extends State<PrimaryCTA>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late Animation<double> _width;
  late Animation<double> _opacity;
  late Animation<double> _opacity2;
  late Animation<Offset> _offset;
  @override
  void initState() {
    super.initState();
    _width = Tween<double>(begin: 50, end: 100).animate(_controller);
    _opacity = Tween<double>(begin: 1, end: 0).animate(_controller);
    _opacity2 = Tween<double>(begin: 0, end: 1).animate(_controller);
    _offset = Tween<Offset>(begin: const Offset(-100, 0), end: Offset.zero)
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      onHover: (hovered) {
        if (hovered) {
          _controller.forward(from: 0);
        } else {
          _controller.reverse(from: 1);
        }
      },
      child: SizedBox(
        height: 50,
        width: 100,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Opacity(
                    opacity: _opacity.value,
                    child: Container(
                      width: _width.value,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: VertexColors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.translate(
                    offset: _offset.value,
                    child: Opacity(
                      opacity: _opacity2.value,
                      child: Container(
                        width: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          color: VertexColors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
