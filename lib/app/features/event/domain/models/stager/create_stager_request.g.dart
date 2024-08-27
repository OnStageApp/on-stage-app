// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_stager_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateStagerRequestImpl _$$CreateStagerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateStagerRequestImpl(
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$$CreateStagerRequestImplToJson(
        _$CreateStagerRequestImpl instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
      'eventId': instance.eventId,
    };
