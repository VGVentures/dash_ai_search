import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SourcesCarouselView extends StatefulWidget {
  const SourcesCarouselView({required this.documents, super.key});

  final List<VertexDocument> documents;

  @override
  State<SourcesCarouselView> createState() => _SourcesCarouselViewState();
}

class _SourcesCarouselViewState extends State<SourcesCarouselView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  List<AnimatedBox> boxes = <AnimatedBox>[];
  static const maxCardsVisible = 4;
  int currentIndex = 0;
  static const incrementsOffset = 300.0;
  static const incrementScale = 0.2;
  List<VertexDocument> allCards = [];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    allCards = List.from(widget.documents);
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
          scale: _getScale(i),
          document: allCards[i],
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
    required this.scale,
    required this.document,
    super.key,
  });

  final AnimationController controller;
  final Animation<Offset> offset;
  final Animation<double> scale;
  final VertexDocument document;

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
                color: VertexColors.arctic,
                child: SourceCard(document: document),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SourceCard extends StatelessWidget {
  const SourceCard({required this.document, super.key});

  final VertexDocument document;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(document.metadata.title),
        const Text('Average page title is 45 characters  | Flutter'),
        const Text(
          'Pressing the back button causes Navigator.pop to be called. On Android, pressing the system back button does the same thing. Using named navigator routes Mobile apps ofter manage a large number of routes and it’s often easiest to refer to them by name.',
        ),
      ],
    );
  }
}
