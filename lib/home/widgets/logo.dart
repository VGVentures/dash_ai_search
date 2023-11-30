import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/bloc/home_bloc.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        const LogoIcon(),
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

class LogoIcon extends StatelessWidget {
  @visibleForTesting
  const LogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeBloc>().add(const Restarted()),
      icon: vertexIcons.asterisk.image(),
    );
  }
}
