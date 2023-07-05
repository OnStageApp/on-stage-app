// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Song _$$_SongFromJson(Map<String, dynamic> json) => _$_Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      albumArtUrl: json['albumArtUrl'] as String,
      youtubeId: json['youtubeId'] as String,
      genre: json['genre'] as String,
      duration: json['duration'] as String,
      year: json['year'] as String,
      lyrics: json['lyrics'] as String,
      tab: json['tab'] as String,
      key: json['key'] as String,
      capo: json['capo'] as String,
      tuning: json['tuning'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$_SongToJson(_$_Song instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'album': instance.album,
      'albumArtUrl': instance.albumArtUrl,
      'youtubeId': instance.youtubeId,
      'genre': instance.genre,
      'duration': instance.duration,
      'year': instance.year,
      'lyrics': instance.lyrics,
      'tab': instance.tab,
      'key': instance.key,
      'capo': instance.capo,
      'tuning': instance.tuning,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
