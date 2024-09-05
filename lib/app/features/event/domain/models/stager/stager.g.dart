// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StagerImpl _$$StagerImplFromJson(Map<String, dynamic> json) => _$StagerImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      profilePicture: json['profilePicture'] as String?,
      participationStatus: $enumDecodeNullable(
          _$StagerStatusEnumEnumMap, json['participationStatus']),
    );

Map<String, dynamic> _$$StagerImplToJson(_$StagerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profilePicture': instance.profilePicture,
      'participationStatus':
          _$StagerStatusEnumEnumMap[instance.participationStatus],
    };

const _$StagerStatusEnumEnumMap = {
  StagerStatusEnum.UNINVINTED: 'UNINVINTED',
  StagerStatusEnum.PENDING: 'PENDING',
  StagerStatusEnum.CONFIRMED: 'CONFIRMED',
  StagerStatusEnum.DECLINED: 'DECLINED',
};
