import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin TransitionScreenMixin<T extends StatefulWidget> on State<T> {
  @protected
  late AnimationController transitionController;

  @protected
  List<Status> inStatuses = [];

  @protected
  List<Status> outStatuses = [];

  @override
  void initState() {
    super.initState();

    transitionIn();

    context.read<HomeBloc>().stream.listen((state) {
      if (inStatuses.contains(state.status)) {
        transitionIn();
      }
      if (outStatuses.contains(state.status)) {
        transitionOut();
      }
    });
  }

  @override
  void dispose() {
    transitionController.dispose();
    super.dispose();
  }

  @protected
  void transitionIn() {
    transitionController.forward();
  }

  @protected
  void transitionOut() {
    transitionController.reverse();
  }
}
