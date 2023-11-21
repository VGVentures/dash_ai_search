import 'package:dash_ai_search/gen/assets.gen.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Positioned(
      top: 40,
      left: 48,
      child: Row(
        children: [
          Text(
            l10n.vertexAI,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 4),
          Assets.icons.asterisk.image(),
          const SizedBox(width: 4),
          Text(
            l10n.flutter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
