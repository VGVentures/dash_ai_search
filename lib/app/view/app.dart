import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:questions_repository/questions_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.questionsRepository,
    super.key,
  });

  final QuestionsRepository questionsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: questionsRepository,
      child: MaterialApp(
        theme: VertexTheme.standard,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
