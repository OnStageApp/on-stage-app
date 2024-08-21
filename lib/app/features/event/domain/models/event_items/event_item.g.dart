// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemImpl _$$EventItemImplFromJson(Map<String, dynamic> json) =>
    _$EventItemImpl(
      name: json['name'] as String?,
      index: (json['index'] as num?)?.toInt(),
      eventType:
          $enumDecodeNullable(_$EventTypeEnumEnumMap, json['event_type']),
      songId: json['song_id'] as String?,
    );

Map<String, dynamic> _$$EventItemImplToJson(_$EventItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'index': instance.index,
      'event_type': _$EventTypeEnumEnumMap[instance.eventType],
      'song_id': instance.songId,
    };

const _$EventTypeEnumEnumMap = {
  EventTypeEnum.song: 'song',
  EventTypeEnum.moment: 'moment',
};
