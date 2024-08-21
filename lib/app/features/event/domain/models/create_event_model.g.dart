// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateEventModelImpl _$$CreateEventModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateEventModelImpl(
      name: json['name'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      stagers:
          (json['stagers'] as List<dynamic>).map((e) => e as String).toList(),
      rehearsals: (json['rehearsals'] as List<dynamic>?)
          ?.map((e) => Rehearsal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateEventModelImplToJson(
        _$CreateEventModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'date': instance.date.toIso8601String(),
      'stagers': instance.stagers,
      'rehearsals': instance.rehearsals?.map((e) => e.toJson()).toList(),
    };
