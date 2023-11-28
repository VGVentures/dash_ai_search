import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_document.g.dart';

/// {@template vertex_document}
/// Vertex document
/// {@endtemplate}
@JsonSerializable()
class VertexDocument extends Equatable {
  /// {@macro vertex_document}
  const VertexDocument({
    required this.id,
    required this.metadata,
  });

  /// Convert from Map<String, dynamic> to [VertexDocument]
  factory VertexDocument.fromJson(Map<String, dynamic> json) =>
      _$VertexDocumentFromJson(json);

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => _$VertexDocumentToJson(this);

  /// Id.
  final String id;

  /// Metadata.
  final VertexMetadata metadata;

  @override
  List<Object?> get props => [metadata, id];
}
