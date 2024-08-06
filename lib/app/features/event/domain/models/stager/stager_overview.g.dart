// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stager_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StagerOverviewImpl _$$StagerOverviewImplFromJson(Map<String, dynamic> json) =>
    _$StagerOverviewImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      picture: json['picture'] as String,
      status: $enumDecode(_$StagerStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$$StagerOverviewImplToJson(
        _$StagerOverviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'picture': instance.picture,
      'status': _$StagerStatusEnumEnumMap[instance.status]!,
    };

const _$StagerStatusEnumEnumMap = {
  StagerStatusEnum.uninvited: 'uninvited',
  StagerStatusEnum.pending: 'pending',
  StagerStatusEnum.accepted: 'accepted',
  StagerStatusEnum.rejected: 'rejected',
};
