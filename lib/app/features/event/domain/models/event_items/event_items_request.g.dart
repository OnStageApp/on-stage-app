// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventItemsRequestImpl _$$EventItemsRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$EventItemsRequestImpl(
      eventItems: (json['eventItems'] as List<dynamic>)
          .map((e) => EventItemCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$$EventItemsRequestImplToJson(
        _$EventItemsRequestImpl instance) =>
    <String, dynamic>{
      'eventItems': instance.eventItems.map((e) => e.toJson()).toList(),
      'eventId': instance.eventId,
    };
