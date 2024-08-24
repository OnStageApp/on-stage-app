// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateEventModelImpl _$$CreateEventModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateEventModelImpl(
      name: json['name'] as String,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String,
      eventStatus: $enumDecode(_$EventStatusEnumMap, json['eventStatus']),
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      rehearsals: (json['rehearsals'] as List<dynamic>)
          .map((e) => RehearsalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateEventModelImplToJson(
        _$CreateEventModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dateTime': instance.dateTime?.toIso8601String(),
      'location': instance.location,
      'eventStatus': _$EventStatusEnumMap[instance.eventStatus]!,
      'userIds': instance.userIds,
      'rehearsals': instance.rehearsals.map((e) => e.toJson()).toList(),
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'draft',
  EventStatus.published: 'published',
};
