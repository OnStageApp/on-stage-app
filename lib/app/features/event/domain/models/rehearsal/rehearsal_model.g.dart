// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rehearsal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RehearsalModelImpl _$$RehearsalModelImplFromJson(Map<String, dynamic> json) =>
    _$RehearsalModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$RehearsalModelImplToJson(
        _$RehearsalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'dateTime': instance.dateTime?.toIso8601String(),
      'eventId': instance.eventId,
    };
