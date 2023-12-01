import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template primary_icon_cta}
/// A button that displays an image on the left side and a text on the right
/// side.
/// {@endtemplate}
class PrimaryIconCTA extends StatefulWidget {
  /// {@macro primary_icon_cta}
  const PrimaryIconCTA({
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
  State<PrimaryIconCTA> createState() => _PrimaryCTAIconState();
}

class _PrimaryCTAIconState extends State<PrimaryIconCTA>
    with SingleTickerProviderStateMixin {
  static const _buttonWidth = 200.0;
  static const _buttonHeight = 64.0;
  static const _circleWidth = 50.0;
  static const _iconSize = 24.0;
  static const _iconAndTextSeparation = _circleWidth + 18.0;

  @visibleForTesting
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late Animation<double> _width;
  late Animation<double> _opacityMainIcon;
  late Animation<double> _opacityOffsetIcon;
  late Animation<Offset> _offset;
  late Animation<double> _iconDimension;
  late Animation<double> _padding;

  @override
  void initState() {
    super.initState();
    _width = Tween<double>(begin: _circleWidth, end: _buttonWidth)
        .animate(controller);
    _opacityMainIcon = Tween<double>(begin: 1, end: 0.1).animate(controller);
    _opacityOffsetIcon = Tween<double>(begin: 0, end: 1).animate(controller);
    _offset = Tween<Offset>(begin: const Offset(-60, 0), end: Offset.zero)
        .animate(controller);
    _iconDimension =
        Tween<double>(begin: _iconSize, end: 0).animate(controller);
    _padding = Tween<double>(begin: 8, end: 0).animate(controller);
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
          controller.forward(from: 0);
        } else {
          controller.reverse(from: 1);
        }
      },
      child: SizedBox(
        height: _buttonHeight,
        width: _buttonWidth,
        child: Stack(
          children: [
            if (widget.icon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    return Padding(
                      padding: EdgeInsets.all(_padding.value),
                      child: Opacity(
                        opacity: _opacityMainIcon.value,
                        child: _Icon(
                          icon: widget.icon!,
                          width: _width.value,
                          iconDimension: _iconDimension.value,
                          hideIcon: controller.isAnimating,
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
                  animation: controller,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: _offset.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Opacity(
                          opacity: _opacityOffsetIcon.value,
                          child: _Icon(
                            icon: widget.icon!,
                            width: _circleWidth,
                            iconDimension: _iconSize,
                            hideIcon: _offset.value != Offset.zero,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Positioned(
              left: _iconAndTextSeparation,
              child: Container(
                height: _buttonHeight,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                ),
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
