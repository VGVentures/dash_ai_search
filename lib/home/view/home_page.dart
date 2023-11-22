import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
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
          InitialScreen(),
        ],
      ),
    );
  }
}
