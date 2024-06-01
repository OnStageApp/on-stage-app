// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongConfigurationImpl _$$SongConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$SongConfigurationImpl(
      teamId: json['teamId'] as String?,
      songId: json['songId'] as String?,
      songKey: json['songKey'] == null
          ? null
          : SongKey.fromJson(json['songKey'] as Map<String, dynamic>),
      structure: (json['structure'] as List<dynamic>?)
          ?.map((e) => SongStructure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SongConfigurationImplToJson(
        _$SongConfigurationImpl instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'songId': instance.songId,
      'songKey': instance.songKey,
      'structure': instance.structure,
    };
