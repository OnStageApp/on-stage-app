// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      favoriteSongs: (json['favoriteSongs'] as List<dynamic>)
          .map((e) => SongOverview.fromJson(e as Map<String, dynamic>))
          .toList(),
      friendsId:
          (json['friendsId'] as List<dynamic>).map((e) => e as String).toList(),
      profileImage: json['profileImage'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'favoriteSongs': instance.favoriteSongs.map((e) => e.toJson()).toList(),
      'friendsId': instance.friendsId,
      'profileImage': instance.profileImage,
      'name': instance.name,
    };
