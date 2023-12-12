import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeSourceAnswersButton extends StatefulWidget {
  @visibleForTesting
  const SeeSourceAnswersButton({super.key});

  @override
  State<SeeSourceAnswersButton> createState() => _SeeSourceAnswersButtonState();
}

class _SeeSourceAnswersButtonState extends State<SeeSourceAnswersButton>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacityExitOut;

  @override
  List<Status> get forwardExitStatuses => [Status.resultsToSourceAnswers];

  @override
  List<Status> get backEnterStatuses => [Status.sourceAnswersBackToResults];

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
    _opacityExitOut =
        Tween<double>(begin: 1, end: 0).animate(exitTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FadeTransition(
      opacity: _opacityExitOut,
      child: Align(
        alignment: Alignment.bottomRight,
        child: TertiaryCTA(
          label: l10n.seeSourceAnswers,
          icon: vertexIcons.arrowForward.image(
            color: VertexColors.white,
          ),
          onPressed: () => context
              .read<HomeBloc>()
              .add(const HomeSeeSourceAnswersRequested(null)),
        ),
      ),
    );
  }
}
