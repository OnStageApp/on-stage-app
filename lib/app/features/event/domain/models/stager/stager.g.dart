// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StagerImpl _$$StagerImplFromJson(Map<String, dynamic> json) => _$StagerImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      picture: json['picture'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: $enumDecode(_$StagerStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$$StagerImplToJson(_$StagerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'picture': instance.picture,
      'email': instance.email,
      'phone': instance.phone,
      'status': _$StagerStatusEnumEnumMap[instance.status]!,
    };

const _$StagerStatusEnumEnumMap = {
  StagerStatusEnum.uninvited: 'uninvited',
  StagerStatusEnum.pending: 'pending',
  StagerStatusEnum.accepted: 'accepted',
  StagerStatusEnum.rejected: 'rejected',
};
