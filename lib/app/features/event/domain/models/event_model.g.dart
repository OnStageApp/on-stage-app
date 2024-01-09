// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      rehearsalDates: (json['rehearsalDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      staggersId: (json['staggersId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adminsId:
          (json['adminsId'] as List<dynamic>).map((e) => e as String).toList(),
      eventItems: (json['eventItems'] as List<dynamic>)
          .map((e) => EventItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'rehearsalDates':
          instance.rehearsalDates.map((e) => e.toIso8601String()).toList(),
      'staggersId': instance.staggersId,
      'adminsId': instance.adminsId,
      'eventItems': instance.eventItems,
      'location': instance.location,
      'imageUrl': instance.imageUrl,
    };
