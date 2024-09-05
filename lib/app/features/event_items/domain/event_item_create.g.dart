// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemCreateImpl _$$EventItemCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$EventItemCreateImpl(
      name: json['name'] as String?,
      index: (json['index'] as num?)?.toInt(),
      songId: json['songId'] as String?,
    );

Map<String, dynamic> _$$EventItemCreateImplToJson(
        _$EventItemCreateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'songId': instance.songId,
    };
