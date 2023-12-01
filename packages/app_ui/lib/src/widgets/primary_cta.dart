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
  static const buttonWidth = 200.0;
  static const buttonHeight = 64.0;
  static const circleWidth = 50.0;
  static const iconDimension = 24.0;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late Animation<double> _width;
  late Animation<double> _opacity;
  late Animation<double> _opacity2;
  late Animation<Offset> _offset;
  late Animation<double> _iconDimension;
  late Animation<double> _padding;
  @override
  void initState() {
    super.initState();
    _width = Tween<double>(begin: circleWidth, end: buttonWidth)
        .animate(_controller);
    _opacity = Tween<double>(begin: 1, end: 0.1).animate(_controller);
    _opacity2 = Tween<double>(begin: 0, end: 1).animate(_controller);
    _offset = Tween<Offset>(begin: const Offset(-50, 0), end: Offset.zero)
        .animate(_controller);
    _iconDimension =
        Tween<double>(begin: iconDimension, end: 0).animate(_controller);
    _padding = Tween<double>(begin: 9, end: 0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onHover: (hovered) {
        if (hovered) {
          _controller.forward(from: 0);
        } else {
          _controller.reverse(from: 1);
        }
      },
      child: SizedBox(
        height: buttonHeight,
        width: buttonWidth,
        child: Stack(
          children: [
            if (widget.icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return Padding(
                      padding: EdgeInsets.all(_padding.value),
                      child: Opacity(
                        opacity: _opacity.value,
                        child: _Icon(
                          icon: widget.icon!,
                          width: _width.value,
                          iconDimension: _iconDimension.value,
                          hideIcon: _controller.isAnimating,
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: _offset.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Opacity(
                          opacity: _opacity2.value,
                          child: _Icon(
                            icon: widget.icon!,
                            width: circleWidth,
                            iconDimension: iconDimension,
                            hideIcon: _offset.value != Offset.zero,
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

class _Icon extends StatelessWidget {
  const _Icon({
    required this.icon,
    required this.width,
    required this.iconDimension,
    required this.hideIcon,
  });

  final Widget icon;
  final double width;
  final double iconDimension;
  final bool hideIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: VertexColors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: hideIcon
          ? const SizedBox()
          : SizedBox.square(dimension: iconDimension, child: icon),
    );
  }
}
