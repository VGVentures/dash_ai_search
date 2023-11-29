import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => WelcomeViewState();
}

class WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin, TransitionScreenMixin {
  late Animation<Offset> _offset;
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcome];

  @override
  List<Status> get forwardExitStatuses => [Status.welcomeToAskQuestion];

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
        .animate(enterTransitionController!);

    _opacity =
        Tween<double>(begin: 1, end: 0).animate(exitTransitionController!);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: const _WelcomeView(),
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final state = context.watch<HomeBloc>().state;

    return IgnorePointer(
      ignoring: !state.isWelcomeVisible,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.initialScreenTitle,
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(
                  color: VertexColors.flutterNavy,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryCTA(
                icon: vertexIcons.arrowForward.image(),
                label: l10n.startAsking,
                onPressed: () =>
                    context.read<HomeBloc>().add(const FromWelcomeToQuestion()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
