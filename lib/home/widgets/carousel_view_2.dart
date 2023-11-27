import 'package:flutter/material.dart';

class CarouselView2 extends StatefulWidget {
  const CarouselView2({super.key});

  @override
  State<CarouselView2> createState() => _CarouselView2State();
}

class _CarouselView2State extends State<CarouselView2>
    with SingleTickerProviderStateMixin {
  List<MaterialColor> allCards = [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];
  late AnimationController animationController;
  List<AnimatedBox> boxes = <AnimatedBox>[];
  static const maxCardsVisible = 3;
  int currentIndex = 0;
  static const incrementsOffset = 250.0;
  static const incrementScale = 0.33;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    setupBoxes();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          currentIndex++;
          final toTheLast = allCards.removeAt(0);
          allCards.add(toTheLast);
          setupBoxes();
        });
      }
    });
  }

  Animation<Offset> _getOffset(int index) {
    if (index == 0) {
      return Tween<Offset>(begin: Offset.zero, end: const Offset(600, 0))
          .animate(
        animationController,
      );
    }
    return Tween<Offset>(
      begin: Offset(incrementsOffset * index, 0),
      end: Offset((incrementsOffset * index) - incrementsOffset, 0),
    ).animate(
      animationController,
    );
  }

  Animation<double> _getScale(int index) {
    if (index == 0) {
      return Tween<double>(begin: 1, end: 0).animate(
        animationController,
      );
    }
    return Tween<double>(
      begin: 1 - (incrementScale * index),
      end: 1 - (incrementScale * index) - incrementScale,
    ).animate(
      animationController,
    );
  }

  void setupBoxes() {
    final children = <AnimatedBox>[];
    animationController.reset();
    for (var i = 0; i < maxCardsVisible; i++) {
      final offset = _getOffset(i);
      children.add(
        AnimatedBox(
          controller: animationController,
          offset: _getOffset(i),
          color: allCards[i],
          scale: _getScale(i),
        ),
      );
    }

    boxes = children;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...boxes,
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            onPressed: () {
              animationController.forward(from: 0);
            },
            child: const Text('Press'),
          ),
        ),
      ],
    );
  }
}

class AnimatedBox extends StatelessWidget {
  const AnimatedBox({
    required this.controller,
    required this.offset,
    required this.color,
    required this.scale,
    super.key,
  });

  final AnimationController controller;
  final Animation<Offset> offset;
  final Color color;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform.scale(
            scale: 1,
            child: Transform.translate(
              offset: offset.value,
              child: Opacity(
                opacity: 1,
                child: Container(
                  height: 300,
                  width: 300,
                  color: color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
