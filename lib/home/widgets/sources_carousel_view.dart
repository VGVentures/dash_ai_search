import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

const _cardHeight = 600.0;
const _cardWidth = 450.0;

class SourcesCarouselView extends StatefulWidget {
  const SourcesCarouselView({
    required this.documents,
    required this.previouslySelectedIndex,
    super.key,
  });

  final List<VertexDocument> documents;
  final int previouslySelectedIndex;

  @override
  State<SourcesCarouselView> createState() => _SourcesCarouselViewState();
}

class _SourcesCarouselViewState extends State<SourcesCarouselView>
    with SingleTickerProviderStateMixin {
  static const maxCardsVisible = 4;
  static const incrementsOffset = 180.0;
  static const decementScale = 0.22;
  static const rotationIncrement = 0.1;
  late AnimationController animationController;
  List<AnimatedBox> animatedBoxes = <AnimatedBox>[];
  List<VertexDocument> documents = [];
  bool isAnimating = false;

  int remainingAnimationCount = 0;

  static const fastAnimationDuration = Duration(milliseconds: 250);
  static const slowAnimationDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: slowAnimationDuration,
    );
    documents = List.from(widget.documents);
    // If we come to this screen with selected index we display that first
    if (widget.previouslySelectedIndex != 0) {
      for (var i = 0; i < widget.previouslySelectedIndex; i++) {
        moveFirstDocument();
      }
    }
    setupAnimatedBoxes();
    setupStatusListener();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant SourcesCarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.previouslySelectedIndex != widget.previouslySelectedIndex) {
      final diff =
          widget.previouslySelectedIndex - oldWidget.previouslySelectedIndex;

      if (diff > 0) {
        // We animate normal
        remainingAnimationCount = diff;
      } else {
        // We need to animate "back"
        remainingAnimationCount =
            (documents.length - oldWidget.previouslySelectedIndex) +
                widget.previouslySelectedIndex;
      }
      animateForward();
    }
  }

  void animateForward() {
    animationController.duration = remainingAnimationCount > 1
        ? fastAnimationDuration
        : slowAnimationDuration;
    animationController.forward(from: 0);
    setState(() {
      remainingAnimationCount = remainingAnimationCount - 1;
    });
  }

  void moveFirstDocument() {
    final toTheLast = documents.removeAt(0);
    documents.add(toTheLast);
  }

  void setupStatusListener() {
    animationController.addStatusListener((status) {
      setState(() {
        isAnimating = status == AnimationStatus.forward ||
            status == AnimationStatus.reverse;
      });
      if (status == AnimationStatus.completed) {
        setState(() {
          moveFirstDocument();
          setupAnimatedBoxes();
          if (remainingAnimationCount > 0) {
            animateForward();
          }
        });
      }
    });
  }

  Animation<Offset> _getOffset(int index) {
    if (index == 0) {
      return Tween<Offset>(begin: Offset.zero, end: const Offset(1000, 0))
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
      return Tween<double>(begin: 1, end: 2).animate(
        animationController,
      );
    }
    final startScale = 1 - (decementScale * index);
    return Tween<double>(
      begin: startScale,
      end: startScale + decementScale,
    ).animate(
      animationController,
    );
  }

  int getDocumentIndex(VertexDocument document) {
    return widget.documents.indexOf(document) + 1;
  }

  Animation<double> _getRotation(int index) {
    if (index == 0) {
      return Tween<double>(begin: 0, end: -1).animate(
        animationController,
      );
    }
    final startRotation = rotationIncrement * index;
    return Tween<double>(
      begin: startRotation,
      end: startRotation - rotationIncrement,
    ).animate(
      animationController,
    );
  }

  void setupAnimatedBoxes() {
    final children = <AnimatedBox>[];
    animationController.reset();
    for (var i = 0; i < maxCardsVisible; i++) {
      children.add(
        AnimatedBox(
          index: getDocumentIndex(documents[i]),
          controller: animationController,
          offset: _getOffset(i),
          scale: _getScale(i),
          document: documents[i],
          rotation: _getRotation(i),
        ),
      );
    }

    animatedBoxes = children.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight + 100,
      padding: const EdgeInsets.only(right: 150),
      child: Stack(
        children: [
          ...animatedBoxes,
          Align(
            alignment: Alignment.bottomCenter,
            child: NextButton(
              animationController: animationController,
              current: getDocumentIndex(animatedBoxes.last.document),
              total: widget.documents.length,
              enabled: !isAnimating,
              onTap: () {
                // Probably moving this to a new bloc event
                final nextIndex = getDocumentIndex(documents.first) + 1;
                context.read<HomeBloc>().add(
                      NavigateSourceAnswers('[$nextIndex]'),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  @visibleForTesting
  const AnimatedBox({
    required this.controller,
    required this.offset,
    required this.scale,
    required this.document,
    required this.index,
    required this.rotation,
    super.key,
  });

  final AnimationController controller;
  final Animation<Offset> offset;
  final Animation<double> scale;
  final VertexDocument document;
  final int index;
  final Animation<double> rotation;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..translate(offset.value.dx, offset.value.dy)
              ..scale(scale.value)
              ..setEntry(3, 2, 0.003)
              ..rotateY(
                rotation.value,
              ),
            child: SourceCard(
              document: document,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class SourceCard extends StatelessWidget {
  @visibleForTesting
  const SourceCard({
    required this.document,
    required this.index,
    this.openLink = launchUrl,
    super.key,
  });

  final VertexDocument document;
  final int index;
  final Future<bool> Function(Uri) openLink;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: _cardHeight,
      width: _cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
      decoration: BoxDecoration(
        color: VertexColors.arctic,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            offset: const Offset(4.5, 4.5),
            blurRadius: 3.59,
            color: Colors.black.withOpacity(0.02),
          ),
          BoxShadow(
            offset: const Offset(12.5, 12.5),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.03),
          ),
          BoxShadow(
            offset: const Offset(20, 20),
            blurRadius: 24,
            color: Colors.black.withOpacity(0.04),
          ),
          BoxShadow(
            offset: const Offset(30, 30),
            blurRadius: 32,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[ $index ]',
                style: textTheme.displaySmall
                    ?.copyWith(color: VertexColors.googleBlue),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                document.metadata.title,
                style: textTheme.displaySmall
                    ?.copyWith(color: VertexColors.flutterNavy),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                document.metadata.description ?? '',
                maxLines: 9,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall
                    ?.copyWith(color: VertexColors.mediumGrey),
              ),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: VertexColors.googleBlue,
              child: IconButton(
                onPressed: () {
                  openLink(Uri.parse(document.metadata.url));
                },
                icon: const Icon(Icons.link_sharp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  @visibleForTesting
  const NextButton({
    required this.animationController,
    required this.current,
    required this.total,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final AnimationController animationController;
  final int current;
  final int total;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      width: _cardWidth,
      height: kMinInteractiveDimension,
      child: TextButton(
        onPressed: enabled ? onTap : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$current/$total',
              style: textTheme.bodyMedium?.copyWith(color: VertexColors.arctic),
            ),
            const SizedBox(
              width: 2,
            ),
            const Icon(
              Icons.arrow_forward,
              color: VertexColors.arctic,
            ),
          ],
        ),
      ),
    );
  }
}
