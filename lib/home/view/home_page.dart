import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: VertexColors.arctic,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: Background(),
          ),
          Positioned(
            top: 40,
            left: 48,
            child: Logo(),
          ),
          WelcomeView(),
          Positioned(
            bottom: 50,
            left: 50,
            child: DashAnimation(),
          ),
        ],
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
    final screenSize = MediaQuery.sizeOf(context);

    return Container(
      alignment: Alignment.center,
      height: screenSize.height / 3,
      width: screenSize.height / 3,
      child: const AnimatedSprite(
        showLoadingIndicator: false,
        sprites: Sprites(
          asset: 'dash_animation.png',
          size: dashSize,
          frames: 34,
          stepTime: 0.07,
        ),
      ),
    );
  }
}
