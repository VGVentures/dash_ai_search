import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.hasDarkBackground = true});

  final bool hasDarkBackground;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textColor =
        hasDarkBackground ? VertexColors.arctic : VertexColors.flutterNavy;
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: textColor,
          letterSpacing: -1,
        );

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () async {
        await launchUrl(
          Uri.parse(
            'https://cloud.google.com/vertex-ai-search-and-conversation?hl=en',
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              l10n.vertexAI,
              style: textStyle,
            ),
            const SizedBox(width: 4),
            vertexIcons.asterisk.image(),
            const SizedBox(width: 4),
            Text(
              l10n.flutter,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
