import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_response.g.dart';

/// {@template vertex_response}
/// Vertex response
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class VertexResponse extends Equatable {
  /// {@macro vertex_response}

  const VertexResponse({
    required this.summary,
    required this.documents,
  });

  /// Convert from Map<String, dynamic> to [VertexResponse]
  factory VertexResponse.fromJson(Map<String, dynamic> json) =>
      _$VertexResponseFromJson(json);

  /// Summary.
  final String summary;

  /// Documents.
  final List<VertexDocument> documents;

  @override
  List<Object?> get props => [
        summary,
        documents,
      ];
}
