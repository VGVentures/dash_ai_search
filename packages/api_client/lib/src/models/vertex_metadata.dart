import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_metadata.g.dart';

/// {@template vertex_metadata}
/// Vertex metadata inside a [VertexDocument]
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class VertexMetadata extends Equatable {
  /// {@macro vertex_metadata}
  const VertexMetadata({
    required this.url,
    required this.title,
    required this.description,
  });

  /// Convert from Map<String, dynamic> to [VertexMetadata]
  factory VertexMetadata.fromJson(Map<String, dynamic> json) =>
      _$VertexMetadataFromJson(json);

  /// Url
  final String url;

  /// Title
  final String title;

  /// Description
  final String description;

  @override
  List<Object?> get props => [url, title, description];
}
