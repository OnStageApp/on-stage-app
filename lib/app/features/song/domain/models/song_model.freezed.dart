// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SongModel _$SongModelFromJson(Map<String, dynamic> json) {
  return _SongModel.fromJson(json);
}

/// @nodoc
mixin _$SongModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get lyrics => throw _privateConstructorUsedError;
  String get tab => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  Artist get artist => throw _privateConstructorUsedError;
  String? get album => throw _privateConstructorUsedError;
  int? get capo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongModelCopyWith<SongModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongModelCopyWith<$Res> {
  factory $SongModelCopyWith(SongModel value, $Res Function(SongModel) then) =
      _$SongModelCopyWithImpl<$Res, SongModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String lyrics,
      String tab,
      String key,
      String createdAt,
      String updatedAt,
      Artist artist,
      String? album,
      int? capo});

  $ArtistCopyWith<$Res> get artist;
}

/// @nodoc
class _$SongModelCopyWithImpl<$Res, $Val extends SongModel>
    implements $SongModelCopyWith<$Res> {
  _$SongModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lyrics = null,
    Object? tab = null,
    Object? key = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? artist = null,
    Object? album = freezed,
    Object? capo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      lyrics: null == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String,
      tab: null == tab
          ? _value.tab
          : tab // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String?,
      capo: freezed == capo
          ? _value.capo
          : capo // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ArtistCopyWith<$Res> get artist {
    return $ArtistCopyWith<$Res>(_value.artist, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SongModelCopyWith<$Res> implements $SongModelCopyWith<$Res> {
  factory _$$_SongModelCopyWith(
          _$_SongModel value, $Res Function(_$_SongModel) then) =
      __$$_SongModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String lyrics,
      String tab,
      String key,
      String createdAt,
      String updatedAt,
      Artist artist,
      String? album,
      int? capo});

  @override
  $ArtistCopyWith<$Res> get artist;
}

/// @nodoc
class __$$_SongModelCopyWithImpl<$Res>
    extends _$SongModelCopyWithImpl<$Res, _$_SongModel>
    implements _$$_SongModelCopyWith<$Res> {
  __$$_SongModelCopyWithImpl(
      _$_SongModel _value, $Res Function(_$_SongModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? lyrics = null,
    Object? tab = null,
    Object? key = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? artist = null,
    Object? album = freezed,
    Object? capo = freezed,
  }) {
    return _then(_$_SongModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      lyrics: null == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String,
      tab: null == tab
          ? _value.tab
          : tab // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      artist: null == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as String?,
      capo: freezed == capo
          ? _value.capo
          : capo // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SongModel implements _SongModel {
  const _$_SongModel(
      {required this.id,
      required this.title,
      required this.lyrics,
      required this.tab,
      required this.key,
      required this.createdAt,
      required this.updatedAt,
      required this.artist,
      this.album,
      this.capo});

  factory _$_SongModel.fromJson(Map<String, dynamic> json) =>
      _$$_SongModelFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String lyrics;
  @override
  final String tab;
  @override
  final String key;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final Artist artist;
  @override
  final String? album;
  @override
  final int? capo;

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, lyrics: $lyrics, tab: $tab, key: $key, createdAt: $createdAt, updatedAt: $updatedAt, artist: $artist, album: $album, capo: $capo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SongModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lyrics, lyrics) || other.lyrics == lyrics) &&
            (identical(other.tab, tab) || other.tab == tab) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.capo, capo) || other.capo == capo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, lyrics, tab, key,
      createdAt, updatedAt, artist, album, capo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SongModelCopyWith<_$_SongModel> get copyWith =>
      __$$_SongModelCopyWithImpl<_$_SongModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SongModelToJson(
      this,
    );
  }
}

abstract class _SongModel implements SongModel {
  const factory _SongModel(
      {required final int id,
      required final String title,
      required final String lyrics,
      required final String tab,
      required final String key,
      required final String createdAt,
      required final String updatedAt,
      required final Artist artist,
      final String? album,
      final int? capo}) = _$_SongModel;

  factory _SongModel.fromJson(Map<String, dynamic> json) =
      _$_SongModel.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get lyrics;
  @override
  String get tab;
  @override
  String get key;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  Artist get artist;
  @override
  String? get album;
  @override
  int? get capo;
  @override
  @JsonKey(ignore: true)
  _$$_SongModelCopyWith<_$_SongModel> get copyWith =>
      throw _privateConstructorUsedError;
}
