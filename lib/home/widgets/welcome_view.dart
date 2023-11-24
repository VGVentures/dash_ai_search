import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/home/widgets/transition_screen_mixin.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin, TransitionScreenMixin {
  late Animation<double> _opacity;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcome];

  @override
  List<Status> get forwardExitStatuses => [Status.welcomeToAskQuestion];

  @override
  void initState() {
    forwardTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    super.initState();

    _opacity =
        Tween<double>(begin: 0, end: 1).animate(forwardTransitionController);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.initialScreenTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge?.copyWith(
                color: VertexColors.navy,
              ),
            ),
            const SizedBox(height: 40),
            CTAButton(
              icon: vertexIcons.arrowForward.image(),
              label: l10n.startAsking,
              onPressed: () =>
                  context.read<HomeBloc>().add(const FromWelcomeToQuestion()),
            ),
          ],
        ),
      ),
    );
  }
}
