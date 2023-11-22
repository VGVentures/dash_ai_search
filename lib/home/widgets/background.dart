import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    const leftOffset = -50.0;
    const radius = 303.0;
    const diameter = radius * 2;

    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Circle(
            offset: Offset(leftOffset, 0),
          ),
          Circle(
            offset: Offset(diameter + leftOffset, 0),
            child: Circle(
              offset: Offset(diameter + leftOffset, 0),
              radius: 255,
              borderColor: Color(0xFFBAC4E1),
              child: Circle(
                offset: Offset(diameter + leftOffset, 0),
                radius: 185,
                borderColor: Color(0xFFBAC4E1),
                dotted: true,
              ),
            ),
          ),
          Circle(
            offset: Offset(diameter * 2 + leftOffset, 0),
          ),
          Circle(
            offset: Offset(diameter * 3 + leftOffset, 0),
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
      ..strokeWidth = 1
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
      canvas.drawCircle(
        offset,
        radius,
        _paintBorder,
      );
    } else {
      canvas.drawCircle(
        offset,
        radius,
        _paintBorder,
      );
    }
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  // coverage:ignore-end
}
