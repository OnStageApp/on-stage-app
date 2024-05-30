// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_structure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongStructureImpl _$$SongStructureImplFromJson(Map<String, dynamic> json) =>
    _$SongStructureImpl(
      $enumDecode(_$StructureItemEnumMap, json['item']),
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$$SongStructureImplToJson(_$SongStructureImpl instance) =>
    <String, dynamic>{
      'item': _$StructureItemEnumMap[instance.item]!,
      'id': instance.id,
    };

const _$StructureItemEnumMap = {
  StructureItem.V1: 'V1',
  StructureItem.V2: 'V2',
  StructureItem.V3: 'V3',
  StructureItem.V4: 'V4',
  StructureItem.V5: 'V5',
  StructureItem.V6: 'V6',
  StructureItem.V7: 'V7',
  StructureItem.C: 'C',
  StructureItem.C1: 'C1',
  StructureItem.C2: 'C2',
  StructureItem.C3: 'C3',
  StructureItem.B: 'B',
  StructureItem.I: 'I',
  StructureItem.I1: 'I1',
  StructureItem.I2: 'I2',
  StructureItem.I3: 'I3',
  StructureItem.B1: 'B1',
  StructureItem.B2: 'B2',
  StructureItem.B3: 'B3',
  StructureItem.E: 'E',
  StructureItem.none: 'none',
};
