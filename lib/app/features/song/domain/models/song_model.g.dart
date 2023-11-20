// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SongModel _$$_SongModelFromJson(Map<String, dynamic> json) => _$_SongModel(
      id: json['id'] as int,
      title: json['title'] as String,
      lyrics: json['lyrics'] as String,
      tab: json['tab'] as String,
      key: json['key'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      artist: Artist.fromJson(json['artist'] as Map<String, dynamic>),
      album: json['album'] as String?,
      capo: json['capo'] as int?,
    );

Map<String, dynamic> _$$_SongModelToJson(_$_SongModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lyrics': instance.lyrics,
      'tab': instance.tab,
      'key': instance.key,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'artist': instance.artist,
      'album': instance.album,
      'capo': instance.capo,
    };
