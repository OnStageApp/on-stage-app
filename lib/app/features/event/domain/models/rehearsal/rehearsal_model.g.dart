// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rehearsal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RehearsalImpl _$$RehearsalImplFromJson(Map<String, dynamic> json) =>
    _$RehearsalImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$$RehearsalImplToJson(_$RehearsalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dateTime': instance.dateTime?.toIso8601String(),
    };
