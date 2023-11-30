import 'dart:async';

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

  StreamSubscription<HomeState>? _streamSubscripton;

  Status? _previousStatus;

  /// Initialize the [AnimationController]s.
  @protected
  void initializeTransitionController() {}

  @override
  void initState() {
    super.initState();

    initializeTransitionController();

    _enterAnimation();

    _streamSubscripton = context.read<HomeBloc>().stream.listen((state) {
      if (_previousStatus == state.status) {
        return;
      }

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

      _previousStatus = state.status;
    });
  }

  @override
  void dispose() {
    enterTransitionController.dispose();
    exitTransitionController.dispose();
    _streamSubscripton?.cancel();
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
