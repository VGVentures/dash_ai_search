import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';

class PulseAnimationView extends StatefulWidget {
  const PulseAnimationView({super.key});

  @override
  State<PulseAnimationView> createState() => _PulseAnimationViewState();
}

const _pulseDuration = Duration(milliseconds: 2000);

class _PulseAnimationViewState extends State<PulseAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController pulseTransitionController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    pulseTransitionController = AnimationController(
      vsync: this,
      duration: _pulseDuration,
    );

    _scale =
        Tween<double>(begin: 1.05, end: .6).animate(pulseTransitionController);
    pulseTransitionController.repeat(reverse: true);
  }

  @override
  void dispose() {
    pulseTransitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.transparent;
    const borderColor = VertexColors.googleBlue;

    return Align(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = constraints.maxHeight < constraints.maxWidth
              ? constraints.maxHeight
              : constraints.maxWidth;

          final bigCircleRadius = viewport / 2;
          final mediumCircleRadius = bigCircleRadius * .59;
          final smallCircleRadius = bigCircleRadius * .27;

          return SizedBox(
            width: viewport,
            height: viewport,
            child: ScaleTransition(
              scale: _scale,
              child: Circle(
                dotted: true,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                radius: bigCircleRadius,
                child: Center(
                  child: Circle(
                    dotted: true,
                    backgroundColor: backgroundColor,
                    borderColor: borderColor,
                    radius: mediumCircleRadius,
                    child: Center(
                      child: Circle(
                        dotted: true,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor,
                        radius: smallCircleRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
