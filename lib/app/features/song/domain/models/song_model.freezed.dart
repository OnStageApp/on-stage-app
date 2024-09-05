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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongModel _$SongModelFromJson(Map<String, dynamic> json) {
  return _SongModel.fromJson(json);
}

/// @nodoc
mixin _$SongModel {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get lyrics => throw _privateConstructorUsedError;
  int? get tempo => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  Artist? get artist => throw _privateConstructorUsedError;
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
      {String? id,
      String? title,
      String? lyrics,
      int? tempo,
      String? key,
      String? createdAt,
      String? updatedAt,
      Artist? artist,
      String? album,
      int? capo});

  $ArtistCopyWith<$Res>? get artist;
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
    Object? id = freezed,
    Object? title = freezed,
    Object? lyrics = freezed,
    Object? tempo = freezed,
    Object? key = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? artist = freezed,
    Object? album = freezed,
    Object? capo = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
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
  $ArtistCopyWith<$Res>? get artist {
    if (_value.artist == null) {
      return null;
    }

    return $ArtistCopyWith<$Res>(_value.artist!, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SongModelImplCopyWith<$Res>
    implements $SongModelCopyWith<$Res> {
  factory _$$SongModelImplCopyWith(
          _$SongModelImpl value, $Res Function(_$SongModelImpl) then) =
      __$$SongModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? lyrics,
      int? tempo,
      String? key,
      String? createdAt,
      String? updatedAt,
      Artist? artist,
      String? album,
      int? capo});

  @override
  $ArtistCopyWith<$Res>? get artist;
}

/// @nodoc
class __$$SongModelImplCopyWithImpl<$Res>
    extends _$SongModelCopyWithImpl<$Res, _$SongModelImpl>
    implements _$$SongModelImplCopyWith<$Res> {
  __$$SongModelImplCopyWithImpl(
      _$SongModelImpl _value, $Res Function(_$SongModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? lyrics = freezed,
    Object? tempo = freezed,
    Object? key = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? artist = freezed,
    Object? album = freezed,
    Object? capo = freezed,
  }) {
    return _then(_$SongModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      lyrics: freezed == lyrics
          ? _value.lyrics
          : lyrics // ignore: cast_nullable_to_non_nullable
              as String?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
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
class _$SongModelImpl extends _SongModel {
  const _$SongModelImpl(
      {this.id,
      this.title,
      this.lyrics,
      this.tempo,
      this.key,
      this.createdAt,
      this.updatedAt,
      this.artist,
      this.album,
      this.capo})
      : super._();

  factory _$SongModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? lyrics;
  @override
  final int? tempo;
  @override
  final String? key;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final Artist? artist;
  @override
  final String? album;
  @override
  final int? capo;

  @override
  String toString() {
    return 'SongModel(id: $id, title: $title, lyrics: $lyrics, tempo: $tempo, key: $key, createdAt: $createdAt, updatedAt: $updatedAt, artist: $artist, album: $album, capo: $capo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.lyrics, lyrics) || other.lyrics == lyrics) &&
            (identical(other.tempo, tempo) || other.tempo == tempo) &&
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
  int get hashCode => Object.hash(runtimeType, id, title, lyrics, tempo, key,
      createdAt, updatedAt, artist, album, capo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongModelImplCopyWith<_$SongModelImpl> get copyWith =>
      __$$SongModelImplCopyWithImpl<_$SongModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongModelImplToJson(
      this,
    );
  }
}

abstract class _SongModel extends SongModel {
  const factory _SongModel(
      {final String? id,
      final String? title,
      final String? lyrics,
      final int? tempo,
      final String? key,
      final String? createdAt,
      final String? updatedAt,
      final Artist? artist,
      final String? album,
      final int? capo}) = _$SongModelImpl;
  const _SongModel._() : super._();

  factory _SongModel.fromJson(Map<String, dynamic> json) =
      _$SongModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get lyrics;
  @override
  int? get tempo;
  @override
  String? get key;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  Artist? get artist;
  @override
  String? get album;
  @override
  int? get capo;
  @override
  @JsonKey(ignore: true)
  _$$SongModelImplCopyWith<_$SongModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
