import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:path_drawing/path_drawing.dart';

class Circle extends StatelessWidget {
  const Circle({
    this.radius = 303,
    this.borderColor = VertexColors.white,
    this.dotted = false,
    this.child,
    this.backgroundColor = VertexColors.white,
    super.key,
  });

  final double radius;
  final Color borderColor;
  final bool dotted;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: radius * 2,
      child: CustomPaint(
        painter: CirclePainter(
          radius: radius,
          borderColor: borderColor,
          dotted: dotted,
          backgroundColor: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @visibleForTesting
  CirclePainter({
    required this.radius,
    required this.borderColor,
    required this.dotted,
    required this.backgroundColor,
  }) {
    _paintCircle = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    _paintBorder = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
  }

  final double radius;
  final Color borderColor;
  final bool dotted;
  final Color backgroundColor;

  late final Paint _paintCircle;
  late final Paint _paintBorder;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..translate(radius, radius)
      ..drawCircle(
        Offset.zero,
        radius,
        _paintCircle,
      );

    if (dotted) {
      const dashPattern = <double>[4, 4];
      final s = radius * 2;

      var path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              -radius,
              -radius,
              s,
              s,
            ),
            Radius.circular(radius),
          ),
        );
      path = dashPath(path, dashArray: CircularIntervalList(dashPattern));
      canvas.drawPath(path, _paintBorder);
    } else {
      canvas.drawCircle(
        Offset.zero,
        radius,
        _paintBorder,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
