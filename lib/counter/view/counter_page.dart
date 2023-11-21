import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CounterView();
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: screenSize.height / 2,
          width: screenSize.height / 2,
          child: const DashAnimation(),
        ),
      ),
    );
  }
}

class DashAnimation extends StatelessWidget {
  @visibleForTesting
  const DashAnimation({super.key});

  static const dashSize = Size(800, 800);

  @override
  Widget build(BuildContext context) {
    return const AnimatedSprite(
      showLoadingIndicator: false,
      sprites: Sprites(
        asset: 'dash_animation.png',
        size: dashSize,
        frames: 34,
        stepTime: 0.07,
      ),
    );
  }
}
