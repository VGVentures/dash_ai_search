import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({
    super.key,
  });

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _width;

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

    _width = Tween<double>(begin: 563, end: 659).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parsed = context.select((HomeBloc bloc) => bloc.state.parsedSummary);

    return AnimatedBuilder(
      animation: _width,
      builder: (context, child) {
        return SizedBox(
          width: _width.value,
          child: RichText(
            text: TextSpan(
              children: [
                for (final element in parsed.elements)
                  if (element.isLink)
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          final isOnSeeSourceAnswers =
                              context.read<HomeBloc>().state.status ==
                                  Status.seeSourceAnswers;
                          if (isOnSeeSourceAnswers) {
                            context.read<HomeBloc>().add(
                                  HomeSourceAnswersNavigated(
                                    element.text,
                                  ),
                                );
                          } else {
                            context.read<HomeBloc>().add(
                                  HomeSeeSourceAnswersRequested(
                                    element.text,
                                  ),
                                );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: VertexColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Text(
                            element.text,
                            style: textTheme.labelLarge?.copyWith(
                              color: VertexColors.googleBlue,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    TextSpan(
                      text: element.text,
                      style: textTheme.headlineLarge?.copyWith(
                        color: VertexColors.white,
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
