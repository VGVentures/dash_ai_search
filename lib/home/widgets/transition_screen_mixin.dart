import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin TransitionScreenMixin<T extends StatefulWidget> on State<T> {
  @protected
  late AnimationController enterTransitionController;

  @protected
  late AnimationController exitTransitionController;

  @protected
  List<Status> forwardEnterStatuses = [];

  @protected
  List<Status> forwardExitStatuses = [];

  @protected
  List<Status> backEnterStatuses = [];

  @protected
  List<Status> backExitStatuses = [];

  @protected
  void initializeTransitionController() {}

  @override
  void initState() {
    super.initState();

    initializeTransitionController();

    enterAnimation();

    context.read<HomeBloc>().stream.listen((state) {
      if (forwardEnterStatuses.contains(state.status)) {
        enterAnimation();
      }
      if (forwardExitStatuses.contains(state.status)) {
        exitAnimation();
      }
      if (backEnterStatuses.contains(state.status)) {
        popEnterAnimation();
      }
      if (backExitStatuses.contains(state.status)) {
        popExitAnimation();
      }
    });
  }

  @override
  void dispose() {
    enterTransitionController.dispose();
    exitTransitionController.dispose();
    super.dispose();
  }

  @protected
  void enterAnimation() {
    enterTransitionController.forward();
  }

  @protected
  void exitAnimation() {
    exitTransitionController.forward();
  }

  @protected
  void popEnterAnimation() {
    exitTransitionController.reverse();
  }

  @protected
  void popExitAnimation() {
    enterTransitionController.reverse();
  }
}
