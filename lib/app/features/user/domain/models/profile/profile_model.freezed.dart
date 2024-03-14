// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  List<SongOverview> get favoriteSongs => throw _privateConstructorUsedError;
  List<String> get friendsId => throw _privateConstructorUsedError;
  String get profileImage => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {List<SongOverview> favoriteSongs,
      List<String> friendsId,
      String profileImage,
      String name});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteSongs = null,
    Object? friendsId = null,
    Object? profileImage = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      favoriteSongs: null == favoriteSongs
          ? _value.favoriteSongs
          : favoriteSongs // ignore: cast_nullable_to_non_nullable
              as List<SongOverview>,
      friendsId: null == friendsId
          ? _value.friendsId
          : friendsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SongOverview> favoriteSongs,
      List<String> friendsId,
      String profileImage,
      String name});
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteSongs = null,
    Object? friendsId = null,
    Object? profileImage = null,
    Object? name = null,
  }) {
    return _then(_$ProfileImpl(
      favoriteSongs: null == favoriteSongs
          ? _value._favoriteSongs
          : favoriteSongs // ignore: cast_nullable_to_non_nullable
              as List<SongOverview>,
      friendsId: null == friendsId
          ? _value._friendsId
          : friendsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {required final List<SongOverview> favoriteSongs,
      required final List<String> friendsId,
      required this.profileImage,
      required this.name})
      : _favoriteSongs = favoriteSongs,
        _friendsId = friendsId;

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  final List<SongOverview> _favoriteSongs;
  @override
  List<SongOverview> get favoriteSongs {
    if (_favoriteSongs is EqualUnmodifiableListView) return _favoriteSongs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteSongs);
  }

  final List<String> _friendsId;
  @override
  List<String> get friendsId {
    if (_friendsId is EqualUnmodifiableListView) return _friendsId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friendsId);
  }

  @override
  final String profileImage;
  @override
  final String name;

  @override
  String toString() {
    return 'Profile(favoriteSongs: $favoriteSongs, friendsId: $friendsId, profileImage: $profileImage, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            const DeepCollectionEquality()
                .equals(other._favoriteSongs, _favoriteSongs) &&
            const DeepCollectionEquality()
                .equals(other._friendsId, _friendsId) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_favoriteSongs),
      const DeepCollectionEquality().hash(_friendsId),
      profileImage,
      name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {required final List<SongOverview> favoriteSongs,
      required final List<String> friendsId,
      required final String profileImage,
      required final String name}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  List<SongOverview> get favoriteSongs;
  @override
  List<String> get friendsId;
  @override
  String get profileImage;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
