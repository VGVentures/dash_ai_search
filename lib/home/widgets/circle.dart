import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:path_drawing/path_drawing.dart';

class Circle extends StatelessWidget {
  const Circle({
    this.offset = Offset.zero,
    this.radius = 303,
    this.borderColor = VertexColors.white,
    this.dotted = false,
    this.child,
    this.backgroundColor = VertexColors.white,
    super.key,
  });

  final Offset offset;
  final double radius;
  final Color borderColor;
  final bool dotted;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        offset: offset,
        radius: radius,
        borderColor: borderColor,
        dotted: dotted,
        backgroundColor: backgroundColor,
      ),
      child: child,
    );
  }
}

class CirclePainter extends CustomPainter {
  @visibleForTesting
  CirclePainter({
    required this.offset,
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

  final Offset offset;
  final double radius;
  final Color borderColor;
  final bool dotted;
  final Color backgroundColor;

  late final Paint _paintCircle;
  late final Paint _paintBorder;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      offset,
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
              offset.dx - s / 2,
              offset.dy / 2 - s / 2,
              s,
              s,
            ),
            Radius.circular(s / 2),
          ),
        );
      path = dashPath(path, dashArray: CircularIntervalList(dashPattern));
      canvas.drawPath(path, _paintBorder);
    } else {
      canvas.drawCircle(
        offset,
        radius,
        _paintBorder,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
