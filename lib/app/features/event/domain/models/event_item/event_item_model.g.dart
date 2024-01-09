// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemImpl _$$EventItemImplFromJson(Map<String, dynamic> json) =>
    _$EventItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      eventType: $enumDecode(_$EventTypeEnumEnumMap, json['eventType']),
      index: json['index'] as int,
      songId: json['songId'] as String?,
    );

Map<String, dynamic> _$$EventItemImplToJson(_$EventItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'eventType': _$EventTypeEnumEnumMap[instance.eventType]!,
      'index': instance.index,
      'songId': instance.songId,
    };

const _$EventTypeEnumEnumMap = {
  EventTypeEnum.song: 'song',
  EventTypeEnum.other: 'other',
};
