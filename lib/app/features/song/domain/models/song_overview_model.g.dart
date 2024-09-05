// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongOverviewImpl _$$SongOverviewImplFromJson(Map<String, dynamic> json) =>
    _$SongOverviewImpl(
      id: json['id'] as String,
      title: json['title'] as String?,
      tempo: (json['tempo'] as num?)?.toInt(),
      key: json['key'] as String?,
      artist: json['artist'] == null
          ? null
          : Artist.fromJson(json['artist'] as Map<String, dynamic>),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$SongOverviewImplToJson(_$SongOverviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tempo': instance.tempo,
      'key': instance.key,
      'artist': instance.artist?.toJson(),
      'isFavorite': instance.isFavorite,
    };
