import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({super.key});

  @override
  State<QuestionView> createState() => QuestionViewState();
}

class QuestionViewState extends State<QuestionView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offsetVerticalIn;
  late Animation<Offset> _offsetVerticalOut;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcomeToAskQuestion];

  @override
  List<Status> get forwardExitStatuses => [Status.askQuestionToThinking];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<HomeBloc>().add(const HomeNavigated(Status.askQuestion));
        }
      });

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void initState() {
    super.initState();
    _offsetVerticalIn =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _offsetVerticalOut =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: SlideTransition(
                position: _offsetVerticalIn,
                child: SlideTransition(
                  position: _offsetVerticalOut,
                  child: Text(
                    l10n.questionScreenTitle,
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge
                        ?.copyWith(color: VertexColors.flutterNavy),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ClipRRect(
              child: SlideTransition(
                position: _offsetVerticalOut,
                child: const SearchBox(
                  shouldAnimate: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
