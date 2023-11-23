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
  const VertexResponse.empty({
    this.summary =
        'To manage states in Flutter, you can use the navigator class. When you press the back button, the Navigator.pop method is called. On Android, pressing the system back button also calls this method . You can also use named navigator routes This is often the easiest way to refer to a large number of routes ',
    this.documents = const [],
  });

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
