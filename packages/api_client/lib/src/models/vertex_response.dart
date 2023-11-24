import 'package:api_client/api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vertex_response.g.dart';

/// {@template vertex_response}
/// Vertex response
/// {@endtemplate}
@JsonSerializable()
class VertexResponse extends Equatable {
  /// {@macro vertex_response}
  const VertexResponse({
    required this.summary,
    required this.documents,
  });

  /// {@macro vertex_response}
  const VertexResponse.empty({this.summary = '', this.documents = const []});

  /// Convert from Map<String, dynamic> to [VertexResponse]
  factory VertexResponse.fromJson(Map<String, dynamic> json) =>
      _$VertexResponseFromJson(json);

  /// Converts this object to a map in JSON format.
  Map<String, dynamic> toJson() => _$VertexResponseToJson(this);

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
