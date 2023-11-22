// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertex_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VertexDocument _$VertexDocumentFromJson(Map<String, dynamic> json) =>
    VertexDocument(
      metadata:
          VertexMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VertexDocumentToJson(VertexDocument instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
    };
