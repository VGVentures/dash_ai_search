import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({this.askAgain = false, super.key});

  final bool askAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchQuery = context.select((HomeBloc bloc) => bloc.state.query);
    return QuestionInputTextField(
      icon: vertexIcons.stars.image(),
      hint: l10n.questionHint,
      actionText: l10n.ask,
      onTextUpdated: (String query) =>
          context.read<HomeBloc>().add(QueryUpdated(query: query)),
      onActionPressed: () {
        if (askAgain) {
          context.read<HomeBloc>().add(const QuestionAskedAgain());
        } else {
          context.read<HomeBloc>().add(const QuestionAsked());
        }
      },
      text: searchQuery.isEmpty ? null : searchQuery,
    );
  }
}
