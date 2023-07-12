// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Artist _$ArtistFromJson(Map<String, dynamic> json) {
  return _Artist.fromJson(json);
}

/// @nodoc
mixin _$Artist {
  int get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  List<int> get songIds => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArtistCopyWith<Artist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtistCopyWith<$Res> {
  factory $ArtistCopyWith(Artist value, $Res Function(Artist) then) =
      _$ArtistCopyWithImpl<$Res, Artist>;
  @useResult
  $Res call({int id, String fullName, List<int> songIds, String? imageUrl});
}

/// @nodoc
class _$ArtistCopyWithImpl<$Res, $Val extends Artist>
    implements $ArtistCopyWith<$Res> {
  _$ArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? songIds = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      songIds: null == songIds
          ? _value.songIds
          : songIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArtistCopyWith<$Res> implements $ArtistCopyWith<$Res> {
  factory _$$_ArtistCopyWith(_$_Artist value, $Res Function(_$_Artist) then) =
      __$$_ArtistCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String fullName, List<int> songIds, String? imageUrl});
}

/// @nodoc
class __$$_ArtistCopyWithImpl<$Res>
    extends _$ArtistCopyWithImpl<$Res, _$_Artist>
    implements _$$_ArtistCopyWith<$Res> {
  __$$_ArtistCopyWithImpl(_$_Artist _value, $Res Function(_$_Artist) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? songIds = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$_Artist(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      songIds: null == songIds
          ? _value._songIds
          : songIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Artist implements _Artist {
  const _$_Artist(
      {required this.id,
      required this.fullName,
      required final List<int> songIds,
      this.imageUrl})
      : _songIds = songIds;

  factory _$_Artist.fromJson(Map<String, dynamic> json) =>
      _$$_ArtistFromJson(json);

  @override
  final int id;
  @override
  final String fullName;
  final List<int> _songIds;
  @override
  List<int> get songIds {
    if (_songIds is EqualUnmodifiableListView) return _songIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songIds);
  }

  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'Artist(id: $id, fullName: $fullName, songIds: $songIds, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Artist &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            const DeepCollectionEquality().equals(other._songIds, _songIds) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName,
      const DeepCollectionEquality().hash(_songIds), imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArtistCopyWith<_$_Artist> get copyWith =>
      __$$_ArtistCopyWithImpl<_$_Artist>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ArtistToJson(
      this,
    );
  }
}

abstract class _Artist implements Artist {
  const factory _Artist(
      {required final int id,
      required final String fullName,
      required final List<int> songIds,
      final String? imageUrl}) = _$_Artist;

  factory _Artist.fromJson(Map<String, dynamic> json) = _$_Artist.fromJson;

  @override
  int get id;
  @override
  String get fullName;
  @override
  List<int> get songIds;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_ArtistCopyWith<_$_Artist> get copyWith =>
      throw _privateConstructorUsedError;
}
