// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StageNotificationImpl _$$StageNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$StageNotificationImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'] as String,
      friendId: json['friendId'] as String?,
      friendPhotoUrl: json['friendPhotoUrl'] as String?,
      eventId: json['eventId'] as String?,
    );

Map<String, dynamic> _$$StageNotificationImplToJson(
        _$StageNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt,
      'friendId': instance.friendId,
      'friendPhotoUrl': instance.friendPhotoUrl,
      'eventId': instance.eventId,
    };
