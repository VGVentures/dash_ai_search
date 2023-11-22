import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    const leftOffset = -50.0;
    const baseRadius = 303.0;
    const baseMediumRadius = 255.0;
    const baseSmallRadius = 185.0;
    const horizontalOffset = baseRadius * 2;

    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Circle(
            offset: Offset(leftOffset, 0),
          ),
          Circle(
            offset: Offset(horizontalOffset + leftOffset, 0),
            child: Circle(
              offset: Offset(horizontalOffset + leftOffset, 0),
              radius: baseMediumRadius,
              borderColor: Color(0xFFDDE2F6),
              child: Circle(
                offset: Offset(horizontalOffset + leftOffset, 0),
                radius: baseSmallRadius,
                borderColor: Color(0xFFDDE2F6),
                dotted: true,
              ),
            ),
          ),
          Circle(
            offset: Offset(horizontalOffset * 2 + leftOffset, 0),
          ),
          Circle(
            offset: Offset(horizontalOffset * 3 + leftOffset, 0),
          ),
        ],
      ),
    );
  }
}

class Circle extends StatelessWidget {
  @visibleForTesting
  const Circle({
    this.offset = Offset.zero,
    this.radius = 303,
    this.borderColor = Colors.white,
    this.dotted = false,
    this.child,
    super.key,
  });

  final Offset offset;
  final double radius;
  final Color borderColor;
  final bool dotted;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        offset: offset,
        radius: radius,
        borderColor: borderColor,
        dotted: dotted,
      ),
      child: child,
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.offset,
    required this.radius,
    required this.borderColor,
    required this.dotted,
  }) {
    _paintCircle = Paint()
      ..color = Colors.white
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
