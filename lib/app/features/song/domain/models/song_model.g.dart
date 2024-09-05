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
      tempo: (json['tempo'] as num?)?.toInt(),
      key: json['key'] as String?,
      songKey: json['songKey'] == null
          ? const SongKey(name: 'Default Key')
          : SongKey.fromJson(json['songKey'] as Map<String, dynamic>),
      originalKey: json['originalKey'] == null
          ? const SongKey(name: 'Oridinal Key')
          : SongKey.fromJson(json['originalKey'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      artist: json['artist'] == null
          ? null
          : Artist.fromJson(json['artist'] as Map<String, dynamic>),
      album: json['album'] as String?,
      capo: (json['capo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SongModelImplToJson(_$SongModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lyrics': instance.lyrics,
      'tempo': instance.tempo,
      'key': instance.key,
      'songKey': instance.songKey?.toJson(),
      'originalKey': instance.originalKey?.toJson(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'artist': instance.artist?.toJson(),
      'album': instance.album,
      'capo': instance.capo,
    };
