// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtistImpl _$$ArtistImplFromJson(Map<String, dynamic> json) => _$ArtistImpl(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      songIds: (json['songIds'] as List<dynamic>).map((e) => e as int).toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$ArtistImplToJson(_$ArtistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'songIds': instance.songIds,
      'imageUrl': instance.imageUrl,
    };
