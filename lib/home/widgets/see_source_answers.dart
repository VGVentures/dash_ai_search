import 'package:app_ui/app_ui.dart';
import 'package:dash_ai_search/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeeSourceAnswers extends StatelessWidget {
  const SeeSourceAnswers({super.key});

  @override
  Widget build(BuildContext context) {
    final response =
        context.select((HomeBloc bloc) => bloc.state.vertexResponse);
    return SizedBox.expand(
      child: ColoredBox(
        color: VertexColors.googleBlue,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 64),
              const SearchBox(),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: _AiResponse(response.summary)),
                  const SizedBox(width: 150),
                  Expanded(
                    child: SourcesCarouselView(documents: response.documents),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiResponse extends StatelessWidget {
  const _AiResponse(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Text(
            text,
            style: textTheme.headlineLarge?.copyWith(
              color: VertexColors.white,
            ),
          ),
          const SizedBox(height: 20),
          const FeedbackButtons(),
        ],
      ),
    );
  }
}
