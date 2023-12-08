import 'package:flutter/material.dart';

class FixedViewport extends StatelessWidget {
  const FixedViewport({
    required this.child,
    this.resolution = const Size(256, 240),
    this.alignment = Alignment.center,
    super.key,
  });

  final Size resolution;

  final Widget child;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final aspectRatio = width / height;
        final resolutionAspectRatio = resolution.width / resolution.height;
        final scale = aspectRatio > resolutionAspectRatio
            ? height / resolution.height
            : width / resolution.width;

        return SizedBox(
          width: width,
          height: height,
          child: Align(
            alignment: alignment,
            child: SizedBox(
              width: resolution.width * scale,
              height: resolution.height * scale,
              child: Transform.scale(
                scale: scale,
                child: Align(
                  child: SizedBox(
                    width: resolution.width,
                    height: resolution.height,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
