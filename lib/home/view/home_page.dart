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
          Background(),
          Logo(),
          InitialScreen(),
        ],
      ),
    );
  }
}
