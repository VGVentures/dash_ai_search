import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.hasDarkBackground = true});

  final bool hasDarkBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final textColor =
        hasDarkBackground ? VertexColors.arctic : VertexColors.flutterNavy;

    return Row(
      children: [
        Text(
          l10n.vertexAI,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(width: 4),
        vertexIcons.asterisk.image(),
        const SizedBox(width: 4),
        Text(
          l10n.flutter,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
