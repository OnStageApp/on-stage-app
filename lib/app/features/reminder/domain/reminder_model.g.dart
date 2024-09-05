// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderImpl _$$ReminderImplFromJson(Map<String, dynamic> json) =>
    _$ReminderImpl(
      daysBefore: (json['daysBefore'] as num).toInt(),
      isSent: json['isSent'] as bool,
    );

Map<String, dynamic> _$$ReminderImplToJson(_$ReminderImpl instance) =>
    <String, dynamic>{
      'daysBefore': instance.daysBefore,
      'isSent': instance.isSent,
    };
