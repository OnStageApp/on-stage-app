// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StageNotification _$$_StageNotificationFromJson(Map<String, dynamic> json) =>
    _$_StageNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'] as String,
      friendId: json['friendId'] as String?,
      friendPhotoUrl: json['friendPhotoUrl'] as String?,
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$_StageNotificationToJson(
        _$_StageNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt,
      'friendId': instance.friendId,
      'friendPhotoUrl': instance.friendPhotoUrl,
      'eventId': instance.eventId,
    };
