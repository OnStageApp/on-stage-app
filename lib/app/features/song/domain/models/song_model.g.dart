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
      songKey: json['song_key'] == null
          ? null
          : SongKey.fromJson(json['song_key'] as Map<String, dynamic>),
      originalKey: json['original_key'] == null
          ? null
          : SongKey.fromJson(json['original_key'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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
      'song_key': instance.songKey?.toJson(),
      'original_key': instance.originalKey?.toJson(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'artist': instance.artist,
      'album': instance.album,
      'capo': instance.capo,
    };
