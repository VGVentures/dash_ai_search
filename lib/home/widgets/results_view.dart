import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);
    return Center(
      child: Container(
        color: VertexColors.googleBlue,
        width: 200,
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(response.summary)],
        ),
      ),
    );
  }
}
