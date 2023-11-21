// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertex_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VertexResponse _$VertexResponseFromJson(Map<String, dynamic> json) =>
    VertexResponse(
      summary: json['summary'] as String,
      documents: (json['documents'] as List<dynamic>)
          .map((e) => VertexDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
