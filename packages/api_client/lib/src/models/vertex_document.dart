import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_document.g.dart';

/// {@template vertex_document}
/// Vertex document
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class VertexDocument extends Equatable {
  /// {@macro vertex_document}
  const VertexDocument({
    required this.metadata,
  });

  /// Convert from Map<String, dynamic> to [VertexDocument]
  factory VertexDocument.fromJson(Map<String, dynamic> json) =>
      _$VertexDocumentFromJson(json);

  /// Metadata.
  final VertexMetadata metadata;

  @override
  List<Object?> get props => [metadata];
}
