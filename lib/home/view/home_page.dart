import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFBAC4E1),
      body: Stack(
        children: [
          const Positioned(
              top: 40,
              left: 48,
              child: Row(
                children: [
                  Text(
                    'Vertex AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Image(
                    image: AssetImage('assets/asterisk.png'),
                  ),
                  Text(
                    'Flutter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ask a question, get \nthe right answer, with \nGoogle Vertex AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF020F30),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextButton.icon(
                    icon: const Image(
                      image: AssetImage('assets/arrow_forward.png'),
                    ),
                    label: const Text(
                      'Start asking',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color(0xFF0273E6),
                      ),
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.only(
                          left: 24,
                          top: 20,
                          bottom: 20,
                          right: 32,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
