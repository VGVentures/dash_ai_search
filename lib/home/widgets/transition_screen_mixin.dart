import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin to handle transitions between screens.
mixin TransitionScreenMixin<T extends StatefulWidget> on State<T> {
  /// The [AnimationController] for the enter transition.
  @protected
  late AnimationController enterTransitionController;

  /// The [AnimationController] for the exit transition.
  @protected
  late AnimationController exitTransitionController;

  /// The [Status]es that trigger the forward enter transition.
  @protected
  List<Status> forwardEnterStatuses = [];

  /// The [Status]es that trigger the forward exit transition.
  @protected
  List<Status> forwardExitStatuses = [];

  /// The [Status]es that trigger the back enter transition.
  @protected
  List<Status> backEnterStatuses = [];

  /// The [Status]es that trigger the back exit transition.
  @protected
  List<Status> backExitStatuses = [];

  /// Initialize the [AnimationController]s.
  @protected
  void initializeTransitionController() {}

  @override
  void initState() {
    super.initState();

    initializeTransitionController();

    _enterAnimation();

    context.read<HomeBloc>().stream.listen((state) {
      if (forwardEnterStatuses.contains(state.status)) {
        _enterAnimation();
      }
      if (forwardExitStatuses.contains(state.status)) {
        _exitAnimation();
      }
      if (backEnterStatuses.contains(state.status)) {
        _popEnterAnimation();
      }
      if (backExitStatuses.contains(state.status)) {
        _popExitAnimation();
      }
    });
  }

  @override
  void dispose() {
    enterTransitionController.dispose();
    exitTransitionController.dispose();
    super.dispose();
  }

  void _enterAnimation() {
    enterTransitionController.forward();
  }

  void _exitAnimation() {
    exitTransitionController.forward();
  }

  void _popEnterAnimation() {
    exitTransitionController.reverse();
  }

  void _popExitAnimation() {
    enterTransitionController.reverse();
  }
}
