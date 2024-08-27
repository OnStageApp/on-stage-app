// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemImpl _$$EventItemImplFromJson(Map<String, dynamic> json) =>
    _$EventItemImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      index: (json['index'] as num?)?.toInt(),
      eventType: $enumDecodeNullable(_$EventItemTypeEnumMap, json['eventType']),
      song: json['song'] == null
          ? null
          : SongOverview.fromJson(json['song'] as Map<String, dynamic>),
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$EventItemImplToJson(_$EventItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'index': instance.index,
      'eventType': _$EventItemTypeEnumMap[instance.eventType],
      'song': instance.song?.toJson(),
      'eventId': instance.eventId,
    };

const _$EventItemTypeEnumMap = {
  EventItemType.song: 'song',
  EventItemType.other: 'other',
};
