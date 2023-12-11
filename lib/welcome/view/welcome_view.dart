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
  late Animation<Offset> _offsetIn;
  late Animation<Offset> _offsetOut;

  @override
  List<Status> get forwardEnterStatuses => [Status.welcome];

  @override
  List<Status> get forwardExitStatuses => [Status.welcomeToAskQuestion];

  @override
  void initializeTransitionController() {
    super.initializeTransitionController();

    enterTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    exitTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void initState() {
    super.initState();

    _offsetIn =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: enterTransitionController,
        curve: Curves.decelerate,
      ),
    );

    _offsetOut =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(
        parent: exitTransitionController,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final status = context.select((HomeBloc bloc) => bloc.state.status);

    return IgnorePointer(
      ignoring: !status.isWelcomeVisible,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                child: SlideTransition(
                  position: _offsetIn,
                  child: SlideTransition(
                    position: _offsetOut,
                    child: Text(
                      l10n.initialScreenTitle,
                      textAlign: TextAlign.center,
                      style: textTheme.displayLarge?.copyWith(
                        color: VertexColors.flutterNavy,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ClipRRect(
                child: SlideTransition(
                  position: _offsetIn,
                  child: SlideTransition(
                    position: _offsetOut,
                    child: PrimaryIconCTA(
                      icon: vertexIcons.arrowForward.image(
                        color: VertexColors.googleBlue,
                      ),
                      label: l10n.startAsking,
                      onPressed: () => context.read<HomeBloc>().add(
                            const HomeNavigated(Status.welcomeToAskQuestion),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
