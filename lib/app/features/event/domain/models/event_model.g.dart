// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      date: json['date'] as String,
      rehearsalsDate: (json['rehearsalsDate'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      staggersId: (json['staggersId'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adminsId:
          (json['adminsId'] as List<dynamic>).map((e) => e as String).toList(),
      eventItemIds: (json['eventItemIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date,
      'rehearsalsDate': instance.rehearsalsDate,
      'staggersId': instance.staggersId,
      'adminsId': instance.adminsId,
      'eventItemIds': instance.eventItemIds,
      'location': instance.location,
      'imageUrl': instance.imageUrl,
    };
