// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tonality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongKeyImpl _$$SongKeyImplFromJson(Map<String, dynamic> json) =>
    _$SongKeyImpl(
      name: json['name'] as String?,
      chord: $enumDecodeNullable(_$ChordsEnumEnumMap, json['chord']),
      isSharp: json['isSharp'] as bool?,
      isMajor: json['isMajor'] as bool?,
    );

Map<String, dynamic> _$$SongKeyImplToJson(_$SongKeyImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'chord': _$ChordsEnumEnumMap[instance.chord],
      'isSharp': instance.isSharp,
      'isMajor': instance.isMajor,
    };

const _$ChordsEnumEnumMap = {
  ChordsEnum.C: 'C',
  ChordsEnum.D: 'D',
  ChordsEnum.E: 'E',
  ChordsEnum.F: 'F',
  ChordsEnum.G: 'G',
  ChordsEnum.A: 'A',
  ChordsEnum.B: 'B',
};
