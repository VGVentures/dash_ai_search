import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackToAnswerButton extends StatefulWidget {
  @visibleForTesting
  const BackToAnswerButton({super.key});

  @override
  State<BackToAnswerButton> createState() => _BackToAnswerButtonState();
}

class _BackToAnswerButtonState extends State<BackToAnswerButton>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _sizeExitIn;

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

    _sizeExitIn = CurvedAnimation(
      parent: exitTransitionController,
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizeTransition(
      sizeFactor: _sizeExitIn,
      axis: Axis.horizontal,
      child: Align(
        alignment: Alignment.topLeft,
        child: TertiaryCTA(
          key: const Key('backToAnswerButtonKey'),
          label: l10n.backToAIAnswer,
          icon: vertexIcons.arrowBack.image(color: VertexColors.white),
          onPressed: () {
            context.read<HomeBloc>().add(const HomeBackToAiSummaryTapped());
          },
        ),
      ),
    );
  }
}
