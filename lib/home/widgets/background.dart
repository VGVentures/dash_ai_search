import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';

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
              borderColor: VertexColors.lilac,
              child: Circle(
                offset: Offset(horizontalOffset + leftOffset, 0),
                radius: baseSmallRadius,
                borderColor: VertexColors.lilac,
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
