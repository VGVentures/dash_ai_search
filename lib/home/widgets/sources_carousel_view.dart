import 'package:flutter/material.dart';

class SourcesCarouselView extends StatefulWidget {
  const SourcesCarouselView({super.key});

  @override
  State<SourcesCarouselView> createState() => _SourcesCarouselViewState();
}

class _SourcesCarouselViewState extends State<SourcesCarouselView>
    with SingleTickerProviderStateMixin {
  List<MaterialColor> allCards = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.yellow,
  ];
  late AnimationController animationController;
  List<AnimatedBox> boxes = <AnimatedBox>[];
  static const maxCardsVisible = 4;
  int currentIndex = 0;
  static const incrementsOffset = 300.0;
  static const incrementScale = 0.2;

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
      return Tween<Offset>(begin: Offset.zero, end: const Offset(5000, 0))
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
      return Tween<double>(begin: 1, end: 1).animate(
        animationController,
      );
    }
    final startScale = 1 - (incrementScale * index);
    return Tween<double>(
      begin: startScale,
      end: startScale + incrementScale,
    ).animate(
      animationController,
    );
  }

  void setupBoxes() {
    final children = <AnimatedBox>[];
    animationController.reset();
    for (var i = 0; i < maxCardsVisible; i++) {
      children.add(
        AnimatedBox(
          controller: animationController,
          offset: _getOffset(i),
          color: allCards[i],
          scale: _getScale(i),
        ),
      );
    }

    boxes = children.reversed.toList();
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
    return Positioned(
      top: 300,
      right: 300,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform.scale(
            scale: scale.value,
            child: Transform.translate(
              offset: offset.value,
              child: Container(
                height: 300,
                width: 300,
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SourceCard extends StatelessWidget {
  const SourceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('[1]'),
        Text('Average page title is 45 characters  | Flutter'),
        Text(
            'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.'),
      ],
    );
  }
}
