import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_metadata.g.dart';

/// {@template vertex_metadata}
/// Vertex metadata inside a [VertexDocument]
/// {@endtemplate}
@JsonSerializable()
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

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => _$VertexMetadataToJson(this);

  /// Url
  final String url;

  /// Title
  final String title;

  /// Description
  final String description;

  @override
  List<Object?> get props => [url, title, description];
}
