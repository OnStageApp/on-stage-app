// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongOverviewImpl _$$SongOverviewImplFromJson(Map<String, dynamic> json) =>
    _$SongOverviewImpl(
      id: json['id'] as String,
      title: json['title'] as String?,
      bpm: (json['bpm'] as num?)?.toInt(),
      key: json['key'] as String?,
      artist: json['artist'] == null
          ? null
          : Artist.fromJson(json['artist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SongOverviewImplToJson(_$SongOverviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'bpm': instance.bpm,
      'key': instance.key,
      'artist': instance.artist,
    };
