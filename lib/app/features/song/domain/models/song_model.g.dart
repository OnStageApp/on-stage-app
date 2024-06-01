// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongModelImpl _$$SongModelImplFromJson(Map<String, dynamic> json) =>
    _$SongModelImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      lyrics: json['lyrics'] as String?,
      bpm: (json['bpm'] as num?)?.toInt(),
      key: json['key'] as String?,
      songKey: json['songKey'] == null
          ? null
          : SongKey.fromJson(json['songKey'] as Map<String, dynamic>),
      originalKey: json['originalKey'] == null
          ? null
          : SongKey.fromJson(json['originalKey'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      artist: json['artist'] as String?,
      album: json['album'] as String?,
      capo: (json['capo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SongModelImplToJson(_$SongModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lyrics': instance.lyrics,
      'bpm': instance.bpm,
      'key': instance.key,
      'songKey': instance.songKey,
      'originalKey': instance.originalKey,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'artist': instance.artist,
      'album': instance.album,
      'capo': instance.capo,
    };
