// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      favoriteSongs: (json['favorite_songs'] as List<dynamic>)
          .map((e) => SongOverview.fromJson(e as Map<String, dynamic>))
          .toList(),
      friendsId: (json['friends_id'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      profileImage: json['profile_image'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'favorite_songs': instance.favoriteSongs.map((e) => e.toJson()).toList(),
      'friends_id': instance.friendsId,
      'profile_image': instance.profileImage,
      'name': instance.name,
    };
