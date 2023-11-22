import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.initialScreenTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            CTAButton(
              icon: vertexIcons.arrowForward.image(),
              label: l10n.startAsking,
            ),
          ],
        ),
      ),
    );
  }
}
