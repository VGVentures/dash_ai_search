import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/question/question.dart';
import 'package:flutter/material.dart';

class SearchBoxView extends StatefulWidget {
  @visibleForTesting
  const SearchBoxView({super.key});

  @override
  State<SearchBoxView> createState() => SearchBoxViewState();
}

class SearchBoxViewState extends State<SearchBoxView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offset;
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.thinkingToResults];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    super.initState();

    _offset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(enterTransitionController);

    _opacity =
        Tween<double>(begin: 0, end: 1).animate(enterTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 659,
      ),
      child: SlideTransition(
        position: _offset,
        child: FadeTransition(
          opacity: _opacity,
          child: const SearchBox(
            askAgain: true,
          ),
        ),
      ),
    );
  }
}
