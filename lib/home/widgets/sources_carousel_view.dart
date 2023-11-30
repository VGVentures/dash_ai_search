import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _cardHeight = 600.0;
const _cardWidth = 450.0;

class SourcesCarouselView extends StatefulWidget {
  const SourcesCarouselView({required this.documents, super.key});

  final List<VertexDocument> documents;

  @override
  State<SourcesCarouselView> createState() => _SourcesCarouselViewState();
}

class _SourcesCarouselViewState extends State<SourcesCarouselView>
    with SingleTickerProviderStateMixin {
  static const maxCardsVisible = 4;
  static const incrementsOffset = 300.0;
  static const incrementScale = 0.2;
  late AnimationController animationController;
  List<AnimatedBox> animatedBoxes = <AnimatedBox>[];
  List<VertexDocument> documents = [];
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    documents = List.from(widget.documents);
    setupAnimatedBoxes();
    setupStatusListener();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void setupStatusListener() {
    animationController.addStatusListener((status) {
      setState(() {
        isAnimating = status == AnimationStatus.forward ||
            status == AnimationStatus.reverse;
      });
      if (status == AnimationStatus.completed) {
        setState(() {
          final toTheLast = documents.removeAt(0);
          documents.add(toTheLast);
          setupAnimatedBoxes();
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

  int index(VertexDocument document) {
    return widget.documents.indexOf(document) + 1;
  }

  void setupAnimatedBoxes() {
    final children = <AnimatedBox>[];
    animationController.reset();
    for (var i = 0; i < maxCardsVisible; i++) {
      children.add(
        AnimatedBox(
          index: index(documents[i]),
          controller: animationController,
          offset: _getOffset(i),
          scale: _getScale(i),
          document: documents[i],
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
              current: index(animatedBoxes.last.document),
              total: widget.documents.length,
              enabled: !isAnimating,
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
    super.key,
  });

  final AnimationController controller;
  final Animation<Offset> offset;
  final Animation<double> scale;
  final VertexDocument document;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Transform.scale(
            scale: scale.value,
            child: Transform.translate(
              offset: offset.value,
              child: SourceCard(
                document: document,
                index: index,
              ),
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
    super.key,
  });

  final AnimationController animationController;
  final int current;
  final int total;
  final bool enabled;

  void onTap() {
    animationController.forward(from: 0);
  }

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
