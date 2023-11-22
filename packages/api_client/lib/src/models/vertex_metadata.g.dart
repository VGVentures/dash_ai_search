// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertex_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VertexMetadata _$VertexMetadataFromJson(Map<String, dynamic> json) =>
    VertexMetadata(
      url: json['url'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$VertexMetadataToJson(VertexMetadata instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
    };
