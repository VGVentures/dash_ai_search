import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin TransitionScreenMixin<T extends StatefulWidget> on State<T> {
  @protected
  late AnimationController forwardTransitionController;

  @protected
  late AnimationController backTransitionController;

  @protected
  List<Status> forwardEnterStatuses = [];

  @protected
  List<Status> forwardExitStatuses = [];

  @protected
  List<Status> backEnterStatuses = [];

  @protected
  List<Status> backExitStatuses = [];

  @override
  void initState() {
    super.initState();

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
    forwardTransitionController.dispose();
    backTransitionController.dispose();
    super.dispose();
  }

  @protected
  void enterAnimation() {
    forwardTransitionController.forward();
  }

  @protected
  void exitAnimation() {
    forwardTransitionController.reverse();
  }

  @protected
  void popEnterAnimation() {
    backTransitionController.forward();
  }

  @protected
  void popExitAnimation() {
    backTransitionController.reverse();
  }
}
