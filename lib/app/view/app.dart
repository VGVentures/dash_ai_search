import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/animations.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:dash_ai_search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_repository/questions_repository.dart';

Size? _routeResolution(String route) {
  final regex = RegExp(r'(\d+)x(\d+)');
  final match = regex.firstMatch(route);
  try {
    if (match != null) {
      return Size(
        double.parse(match.group(1)!),
        double.parse(match.group(2)!),
      );
    }
  } catch (_) {
    // If there is an error, we will just return null
  }

  return null;
}

@visibleForTesting
MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings route) {
  final fixedResolution = _routeResolution(route.name ?? '');
  return MaterialPageRoute(
    builder: (_) {
      if (fixedResolution != null) {
        return FixedViewport(
          resolution: fixedResolution,
          child: const HomePage(),
        );
      }
      return const HomePage();
    },
  );
}

class App extends StatelessWidget {
  const App({
    required this.questionsRepository,
    required this.dashAnimations,
    super.key,
  });

  final QuestionsRepository questionsRepository;
  final DashAnimations dashAnimations;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: questionsRepository,
        ),
        RepositoryProvider.value(
          value: dashAnimations,
        ),
      ],
      child: MaterialApp(
        theme: VertexTheme.standard,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
