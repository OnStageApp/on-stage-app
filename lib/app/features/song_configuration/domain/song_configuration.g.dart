// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongConfigurationImpl _$$SongConfigurationImplFromJson(
        Map<String, dynamic> json) =>
    _$SongConfigurationImpl(
      teamId: json['team_id'] as String?,
      songId: json['song_id'] as String?,
      songKey: json['song_key'] == null
          ? null
          : SongKey.fromJson(json['song_key'] as Map<String, dynamic>),
      structure: (json['structure'] as List<dynamic>?)
          ?.map((e) => SongStructure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SongConfigurationImplToJson(
        _$SongConfigurationImpl instance) =>
    <String, dynamic>{
      'team_id': instance.teamId,
      'song_id': instance.songId,
      'song_key': instance.songKey?.toJson(),
      'structure': instance.structure?.map((e) => e.toJson()).toList(),
    };
