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
    with TickerProviderStateMixin {
  static const incrementsOffset = 180.0;
  static const decrementScale = 0.22;
  static const rotationIncrement = 0.1;
  late AnimationController nextAnimationController;
  late AnimationController backAnimationController;
  List<AnimatedBox> animatedBoxes = <AnimatedBox>[];
  List<VertexDocument> documents = [];
  bool isAnimating = false;
  bool isResetingList = false;
  bool isResetingListBackwards = false;

  bool goingForward = true;
  int remainingAnimationCount = 0;

  static const fastAnimationDuration = Duration(milliseconds: 250);
  static const slowAnimationDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    nextAnimationController = AnimationController(
      vsync: this,
      duration: slowAnimationDuration,
    );
    backAnimationController = AnimationController(
      vsync: this,
      duration: slowAnimationDuration,
    );
    documents = List.from(widget.documents);
    // If we come to this screen with selected index we display that first
    if (widget.previouslySelectedIndex != 0) {
      for (var i = 0; i < widget.previouslySelectedIndex; i++) {
        moveDocumentForward();
      }
    }
    moveDocumentBackwards();
    setupAnimatedBoxes();
    setupStatusListener();
  }

  @override
  void dispose() {
    super.dispose();
    nextAnimationController.dispose();
    backAnimationController.dispose();
  }

  @override
  void didUpdateWidget(covariant SourcesCarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.previouslySelectedIndex != widget.previouslySelectedIndex) {
      final distance =
          widget.previouslySelectedIndex - oldWidget.previouslySelectedIndex;

      if (oldWidget.previouslySelectedIndex == widget.documents.length - 1 &&
          widget.previouslySelectedIndex == 0) {
        // We are at the end and we need to go to the beginning
        remainingAnimationCount = 1;
        animateForward();
        isResetingList = true;
      } else if (oldWidget.previouslySelectedIndex == 0 &&
          widget.previouslySelectedIndex == widget.documents.length - 1) {
        // We are at the beginning and we need to go to the end
        remainingAnimationCount = -1;
        animateBack();
        isResetingListBackwards = true;
      } else if (widget.previouslySelectedIndex >=
          oldWidget.previouslySelectedIndex) {
        // We animate normal
        remainingAnimationCount = distance;
        animateForward();
      } else {
        // We need to animate "back"
        remainingAnimationCount = distance;
        animateBack();
      }
    }
  }

  void animateForward() {
    nextAnimationController
      ..duration = remainingAnimationCount.abs() > 1
          ? fastAnimationDuration
          : slowAnimationDuration
      ..forward(from: 0);

    setState(() {
      remainingAnimationCount = remainingAnimationCount - 1;
    });
  }

  void animateBack() {
    backAnimationController
      ..duration = remainingAnimationCount.abs() > 1
          ? fastAnimationDuration
          : slowAnimationDuration
      ..forward(from: 0);

    setState(() {
      remainingAnimationCount = remainingAnimationCount + 1;
    });
  }

  void moveDocumentForward() {
    final toTheLast = documents.removeAt(0);
    documents.add(toTheLast);
  }

  void moveDocumentBackwards() {
    final toTheLast = documents.removeLast();
    documents.insert(0, toTheLast);
  }

  int getDocumentIndex(VertexDocument document) {
    return widget.documents.indexOf(document) + 1;
  }

  void setupStatusListener() {
    nextAnimationController.addStatusListener((status) {
      setState(() {
        isAnimating = status == AnimationStatus.forward ||
            status == AnimationStatus.reverse;
      });
      if (status == AnimationStatus.completed) {
        setState(() {
          if (!isResetingList) {
            moveDocumentForward();
          } else {
            documents = List.from(widget.documents);
            isResetingList = false;
            moveDocumentBackwards();
          }
          setupAnimatedBoxes();
          if (remainingAnimationCount != 0) {
            animateForward();
          }
        });
      }
    });

    backAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (!isResetingListBackwards) {
            moveDocumentBackwards();
          } else {
            final newList =
                List<VertexDocument>.from(widget.documents).toList();
            final lastElement = newList.removeLast();
            final previousToLastElement = newList.removeLast();
            documents = [
              previousToLastElement,
              lastElement,
              ...newList,
            ];
            isResetingListBackwards = false;
          }
          setupAnimatedBoxes();
          if (remainingAnimationCount != 0) {
            animateBack();
          }
        });
      }
    });
  }

  Animation<Offset> _getOffsetForward(int index) {
    if (index == 0) {
      return Tween<Offset>(
        begin: const Offset(1000, 0),
        end: const Offset(1000, 0),
      ).animate(
        nextAnimationController,
      );
    }

    if (index == 1) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1000, 0),
      ).animate(
        nextAnimationController,
      );
    }

    return Tween<Offset>(
      begin: Offset((incrementsOffset * index) - incrementsOffset, 0),
      end: Offset(
        (incrementsOffset * index) - incrementsOffset - incrementsOffset,
        0,
      ),
    ).animate(
      nextAnimationController,
    );
  }

  Animation<Offset> _getOffsetBack(int index) {
    if (index == 0) {
      return Tween<Offset>(begin: const Offset(1000, 0), end: Offset.zero)
          .animate(
        backAnimationController,
      );
    }
    if (index == 1) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(incrementsOffset, 0),
      ).animate(
        backAnimationController,
      );
    }
    final startOffset =
        Offset((incrementsOffset * index) - incrementsOffset, 0);
    return Tween<Offset>(
      begin: startOffset,
      end: startOffset + const Offset(incrementsOffset, 0),
    ).animate(
      backAnimationController,
    );
  }

  Animation<double> _getScaleForward(int index) {
    if (index == 0) {
      return Tween<double>(begin: 2, end: 2).animate(
        nextAnimationController,
      );
    }
    if (index == 1) {
      return Tween<double>(begin: 1, end: 2).animate(
        nextAnimationController,
      );
    }
    final startScale = 1 - (decrementScale * index) + decrementScale;
    return Tween<double>(
      begin: startScale,
      end: startScale + decrementScale,
    ).animate(
      nextAnimationController,
    );
  }

  Animation<double> _getScaleBack(int index) {
    if (index == 0) {
      return Tween<double>(begin: 2, end: 1).animate(
        backAnimationController,
      );
    }
    if (index == 1) {
      return Tween<double>(
        begin: 1,
        end: 1 - decrementScale,
      ).animate(
        backAnimationController,
      );
    }
    final startScale = 1 - (decrementScale * index) + decrementScale;
    return Tween<double>(
      begin: startScale,
      end: startScale - decrementScale,
    ).animate(
      backAnimationController,
    );
  }

  Animation<double> _getRotationForward(int index) {
    if (index == 0) {
      return Tween<double>(begin: -1, end: -1).animate(
        nextAnimationController,
      );
    }
    if (index == 1) {
      return Tween<double>(begin: 0, end: -1).animate(
        nextAnimationController,
      );
    }
    final startRotation = (rotationIncrement * index) - rotationIncrement;
    return Tween<double>(
      begin: startRotation,
      end: startRotation - rotationIncrement,
    ).animate(
      nextAnimationController,
    );
  }

  Animation<double> _getRotationBack(int index) {
    if (index == 0) {
      return Tween<double>(begin: -1, end: 0).animate(
        backAnimationController,
      );
    }

    if (index == 1) {
      return Tween<double>(begin: 0, end: rotationIncrement).animate(
        backAnimationController,
      );
    }

    final startRotation = (rotationIncrement * index) - rotationIncrement;
    return Tween<double>(
      begin: startRotation,
      end: startRotation + rotationIncrement,
    ).animate(
      backAnimationController,
    );
  }

  void setupAnimatedBoxes() {
    final children = <AnimatedBox>[];
    nextAnimationController.reset();
    backAnimationController.reset();
    for (var i = 0; i < documents.length; i++) {
      children.add(
        AnimatedBox(
          index: getDocumentIndex(documents[i]),
          nextAnimationController: nextAnimationController,
          backAnimationController: backAnimationController,
          nextOffset: _getOffsetForward(i),
          backOffset: _getOffsetBack(i),
          nextScale: _getScaleForward(i),
          backScale: _getScaleBack(i),
          document: documents[i],
          nextRotation: _getRotationForward(i),
          backRotation: _getRotationBack(i),
          color: Colors.white,
        ),
      );
    }

    animatedBoxes = children.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final index =
        getDocumentIndex(animatedBoxes[documents.length - 2].document);
    final total = documents.length;
    return Container(
      height: _cardHeight + 100,
      padding: const EdgeInsets.only(right: 150),
      child: Stack(
        children: [
          ...animatedBoxes,
          Align(
            alignment: Alignment.bottomCenter,
            child: _NavigationButtons(
              counter: '$index/$total',
              onBackPressed: () {
                final nextIndex = getDocumentIndex(documents[0]);
                context.read<HomeBloc>().add(
                      HomeSourceAnswersNavigated('[$nextIndex]'),
                    );
              },
              onNextPressed: () {
                final nextIndex = getDocumentIndex(documents[2]);
                context.read<HomeBloc>().add(
                      HomeSourceAnswersNavigated('[$nextIndex]'),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.onBackPressed,
    required this.onNextPressed,
    required this.counter,
  });

  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final String counter;

  @override
  Widget build(BuildContext context) {
    const color = VertexColors.white;
    return Row(
      children: [
        GoPreviousButton(
          onBackPressed: onBackPressed,
        ),
        const SizedBox(width: 4),
        Text(
          counter,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
        const SizedBox(width: 4),
        GoNextButton(
          onNextPressed: onNextPressed,
        ),
      ],
    );
  }
}

class GoPreviousButton extends StatelessWidget {
  @visibleForTesting
  const GoPreviousButton({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    const color = VertexColors.white;
    return NavigationButton(
      icon: vertexIcons.arrowBack.image(color: color),
      onTap: onBackPressed,
    );
  }
}

class GoNextButton extends StatelessWidget {
  @visibleForTesting
  const GoNextButton({required this.onNextPressed, super.key});

  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    const color = VertexColors.white;
    return NavigationButton(
      icon: vertexIcons.arrowForward.image(color: color),
      onTap: onNextPressed,
    );
  }
}

class NavigationButton extends StatefulWidget {
  @visibleForTesting
  const NavigationButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final VoidCallback onTap;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  var _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (bool hover) {
        setState(() {
          _isHovering = hover;
        });
      },
      onTap: widget.onTap,
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: _isHovering
                ? VertexColors.white.withOpacity(.1)
                : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

class AnimatedBox extends StatelessWidget {
  @visibleForTesting
  const AnimatedBox({
    required this.index,
    required this.document,
    required this.nextAnimationController,
    required this.backAnimationController,
    required this.nextOffset,
    required this.backOffset,
    required this.nextScale,
    required this.backScale,
    required this.nextRotation,
    required this.backRotation,
    required this.color,
    super.key,
  });

  final AnimationController nextAnimationController;
  final AnimationController backAnimationController;
  final Animation<Offset> nextOffset;
  final Animation<Offset> backOffset;
  final Animation<double> nextScale;
  final Animation<double> backScale;
  final VertexDocument document;
  final int index;
  final Animation<double> nextRotation;
  final Animation<double> backRotation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedBuilder(
        animation: backAnimationController,
        builder: (_, __) => AnimatedBuilder(
          animation: nextAnimationController,
          builder: (_, __) {
            final offsetFinal =
                backAnimationController.isAnimating ? backOffset : nextOffset;
            final scaleFinal =
                backAnimationController.isAnimating ? backScale : nextScale;
            final rotationFinal = backAnimationController.isAnimating
                ? backRotation
                : nextRotation;
            return Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..translate(
                  offsetFinal.value.dx,
                  offsetFinal.value.dy,
                )
                ..scale(scaleFinal.value)
                ..setEntry(3, 2, 0.003)
                ..rotateY(
                  rotationFinal.value,
                ),
              child: SourceCard(
                document: document,
                index: index,
              ),
            );
          },
        ),
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
        color: VertexColors.deepArctic,
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
