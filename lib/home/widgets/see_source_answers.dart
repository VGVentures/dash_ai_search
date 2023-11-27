import 'package:api_client/api_client.dart';
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
    return ColoredBox(
      color: VertexColors.googleBlue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          children: [
            Expanded(child: _AiResponse(response.summary)),
            const SizedBox(width: 150),
            Expanded(child: _ResponseCarousel(response.documents)),
          ],
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
    return Column(
      children: [
        Text(
          text,
          style: VertexTextStyles.body.copyWith(
            color: VertexColors.white,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 20),
        const FeedbackButtons(),
      ],
    );
  }
}

class _ResponseCarousel extends StatelessWidget {
  const _ResponseCarousel(this.documents);

  final List<VertexDocument> documents;

  @override
  Widget build(BuildContext context) {
    return SourcesCarouselView(
      documents: documents,
    );
  }
}
