// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemImpl _$$EventItemImplFromJson(Map<String, dynamic> json) =>
    _$EventItemImpl(
      name: json['name'] as String?,
      index: json['index'] as int?,
      eventType: json['eventType'] as String?,
      songId: json['songId'] as String?,
    );

Map<String, dynamic> _$$EventItemImplToJson(_$EventItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'eventType': instance.eventType,
      'songId': instance.songId,
    };
