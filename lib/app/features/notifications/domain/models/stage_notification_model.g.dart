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
      createdAt: json['created_at'] as String,
      friendId: json['friend_id'] as String?,
      friendPhotoUrl: json['friend_photo_url'] as String?,
      eventId: json['event_id'] as String?,
    );

Map<String, dynamic> _$$StageNotificationImplToJson(
        _$StageNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'created_at': instance.createdAt,
      'friend_id': instance.friendId,
      'friend_photo_url': instance.friendPhotoUrl,
      'event_id': instance.eventId,
    };
