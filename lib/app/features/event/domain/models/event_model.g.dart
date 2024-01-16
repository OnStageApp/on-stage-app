// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      rehearsalDates: (json['rehearsalDates'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      eventItems: (json['eventItems'] as List<dynamic>?)
          ?.map((e) => EventItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'rehearsalDates':
          instance.rehearsalDates?.map((e) => e.toIso8601String()).toList(),
      'eventItems': instance.eventItems,
      'location': instance.location,
    };
