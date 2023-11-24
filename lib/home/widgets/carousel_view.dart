import 'package:flutter/material.dart';

class CarouselView extends StatefulWidget {
  const CarouselView({super.key});

  @override
  State<CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView>
    with SingleTickerProviderStateMixin {
  List<MaterialColor> cards = [
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  int index = 0;
  int max = 4;

  late List<Animation<Offset>> offsetAnimations;

  late AnimationController animationController;
  late Animation<Offset> mainOffsetAnimation;
  late Animation<Offset> secondOffSetAnimation;
  late Animation<double> secondScaleAnimation;

  static const incrementsOffset = 200.0;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    setupControllers();
    secondScaleAnimation =
        Tween<double>(begin: 0.8, end: 1).animate(animationController);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          index = index + 1;
          final colorRemoved = cards.removeAt(0);
          cards.add(colorRemoved);
        });
      }
    });
  }

  void setupControllers() {
    offsetAnimations = [];
    for (var i = 0; i < cards.length; i++) {
      if (i == 0) {
        offsetAnimations.add(
          Tween<Offset>(begin: Offset.zero, end: const Offset(-1000, 0))
              .animate(
            animationController,
          ),
        );
      } else {
        offsetAnimations.add(
          Tween<Offset>(
            begin: Offset(incrementsOffset * i, 0),
            end: Offset((incrementsOffset * i) - incrementsOffset, 0),
          ).animate(
            animationController,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          for (var i = 0; i < cards.length; i++)
            Align(
              child: AnimatedBox(
                controller: animationController,
                animation: offsetAnimations[i],
                color: cards[i],
              ),
            ),
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
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  const AnimatedBox({
    required this.controller,
    required this.animation,
    required this.color,
    super.key,
  });

  final AnimationController controller;
  final Animation<Offset> animation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform.translate(
            offset: animation.value,
            child: Container(
              height: 300,
              width: 300,
              color: color,
            ),
          );
        },
      ),
    );
  }
}
