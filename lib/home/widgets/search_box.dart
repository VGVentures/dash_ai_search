import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:dash_ai_search/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    this.shouldAnimate = false,
    this.askAgain = false,
    super.key,
  });

  final bool askAgain;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        final searchQuery = state.query;
        final submittedQuery = state.submittedQuery;
        return QuestionInputTextField(
          shouldAnimate: shouldAnimate,
          shouldDisplayClearTextButton: searchQuery == submittedQuery,
          icon: vertexIcons.stars.image(),
          hint: l10n.questionHint,
          actionText: l10n.ask,
          onTextUpdated: (String query) =>
              context.read<HomeBloc>().add(HomeQueryUpdated(query: query)),
          onActionPressed: () {
            if (askAgain) {
              context.read<HomeBloc>().add(HomeQuestionAskedAgain(searchQuery));
            } else {
              context.read<HomeBloc>().add(HomeQuestionAsked(searchQuery));
            }
          },
          text: searchQuery.isEmpty ? null : searchQuery,
        );
      },
    );
  }
}
