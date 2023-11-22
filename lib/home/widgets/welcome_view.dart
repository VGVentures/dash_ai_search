import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.initialScreenTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w700,
                color: Color(0xFF020F30),
              ),
            ),
            const SizedBox(height: 40),
            CTAButton(
              icon: VertexIcons.arrowForward.image(),
              label: l10n.startAsking,
            ),
          ],
        ),
      ),
    );
  }
}
