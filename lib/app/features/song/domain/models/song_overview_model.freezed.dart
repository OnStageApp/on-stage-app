// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongOverview _$SongOverviewFromJson(Map<String, dynamic> json) {
  return _SongOverview.fromJson(json);
}

/// @nodoc
mixin _$SongOverview {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get tempo => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;
  Artist? get artist => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongOverviewCopyWith<SongOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongOverviewCopyWith<$Res> {
  factory $SongOverviewCopyWith(
          SongOverview value, $Res Function(SongOverview) then) =
      _$SongOverviewCopyWithImpl<$Res, SongOverview>;
  @useResult
  $Res call(
      {String id, String? title, int? tempo, String? key, Artist? artist});

  $ArtistCopyWith<$Res>? get artist;
}

/// @nodoc
class _$SongOverviewCopyWithImpl<$Res, $Val extends SongOverview>
    implements $SongOverviewCopyWith<$Res> {
  _$SongOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? tempo = freezed,
    Object? key = freezed,
    Object? artist = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
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
abstract class _$$SongOverviewImplCopyWith<$Res>
    implements $SongOverviewCopyWith<$Res> {
  factory _$$SongOverviewImplCopyWith(
          _$SongOverviewImpl value, $Res Function(_$SongOverviewImpl) then) =
      __$$SongOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String? title, int? tempo, String? key, Artist? artist});

  @override
  $ArtistCopyWith<$Res>? get artist;
}

/// @nodoc
class __$$SongOverviewImplCopyWithImpl<$Res>
    extends _$SongOverviewCopyWithImpl<$Res, _$SongOverviewImpl>
    implements _$$SongOverviewImplCopyWith<$Res> {
  __$$SongOverviewImplCopyWithImpl(
      _$SongOverviewImpl _value, $Res Function(_$SongOverviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? tempo = freezed,
    Object? key = freezed,
    Object? artist = freezed,
  }) {
    return _then(_$SongOverviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      tempo: freezed == tempo
          ? _value.tempo
          : tempo // ignore: cast_nullable_to_non_nullable
              as int?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as Artist?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongOverviewImpl implements _SongOverview {
  const _$SongOverviewImpl(
      {required this.id, this.title, this.tempo, this.key, this.artist});

  factory _$SongOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongOverviewImplFromJson(json);

  @override
  final String id;
  @override
  final String? title;
  @override
  final int? tempo;
  @override
  final String? key;
  @override
  final Artist? artist;

  @override
  String toString() {
    return 'SongOverview(id: $id, title: $title, tempo: $tempo, key: $key, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongOverviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.tempo, tempo) || other.tempo == tempo) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.artist, artist) || other.artist == artist));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, tempo, key, artist);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongOverviewImplCopyWith<_$SongOverviewImpl> get copyWith =>
      __$$SongOverviewImplCopyWithImpl<_$SongOverviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongOverviewImplToJson(
      this,
    );
  }
}

abstract class _SongOverview implements SongOverview {
  const factory _SongOverview(
      {required final String id,
      final String? title,
      final int? tempo,
      final String? key,
      final Artist? artist}) = _$SongOverviewImpl;

  factory _SongOverview.fromJson(Map<String, dynamic> json) =
      _$SongOverviewImpl.fromJson;

  @override
  String get id;
  @override
  String? get title;
  @override
  int? get tempo;
  @override
  String? get key;
  @override
  Artist? get artist;
  @override
  @JsonKey(ignore: true)
  _$$SongOverviewImplCopyWith<_$SongOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
