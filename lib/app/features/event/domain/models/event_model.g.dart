// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String?,
      eventStatus:
          $enumDecodeNullable(_$EventStatusEnumMap, json['eventStatus']),
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dateTime': instance.dateTime?.toIso8601String(),
      'location': instance.location,
      'eventStatus': _$EventStatusEnumMap[instance.eventStatus],
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'draft',
  EventStatus.published: 'published',
};
