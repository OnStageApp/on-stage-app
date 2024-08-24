// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemImpl _$$EventItemImplFromJson(Map<String, dynamic> json) =>
    _$EventItemImpl(
      name: json['name'] as String?,
      index: (json['index'] as num?)?.toInt(),
      eventType: $enumDecodeNullable(_$EventTypeEnumEnumMap, json['eventType']),
      songId: json['songId'] as String?,
    );

Map<String, dynamic> _$$EventItemImplToJson(_$EventItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'eventType': _$EventTypeEnumEnumMap[instance.eventType],
      'songId': instance.songId,
    };

const _$EventTypeEnumEnumMap = {
  EventTypeEnum.song: 'song',
  EventTypeEnum.moment: 'moment',
};
