// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongConfiguration _$SongConfigurationFromJson(Map<String, dynamic> json) {
  return _SongConfiguration.fromJson(json);
}

/// @nodoc
mixin _$SongConfiguration {
  String? get teamId => throw _privateConstructorUsedError;
  String? get songId => throw _privateConstructorUsedError;
  SongKey? get songKey => throw _privateConstructorUsedError;
  List<SongStructure>? get structure => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongConfigurationCopyWith<SongConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongConfigurationCopyWith<$Res> {
  factory $SongConfigurationCopyWith(
          SongConfiguration value, $Res Function(SongConfiguration) then) =
      _$SongConfigurationCopyWithImpl<$Res, SongConfiguration>;
  @useResult
  $Res call(
      {String? teamId,
      String? songId,
      SongKey? songKey,
      List<SongStructure>? structure});

  $SongKeyCopyWith<$Res>? get songKey;
}

/// @nodoc
class _$SongConfigurationCopyWithImpl<$Res, $Val extends SongConfiguration>
    implements $SongConfigurationCopyWith<$Res> {
  _$SongConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamId = freezed,
    Object? songId = freezed,
    Object? songKey = freezed,
    Object? structure = freezed,
  }) {
    return _then(_value.copyWith(
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      songId: freezed == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String?,
      songKey: freezed == songKey
          ? _value.songKey
          : songKey // ignore: cast_nullable_to_non_nullable
              as SongKey?,
      structure: freezed == structure
          ? _value.structure
          : structure // ignore: cast_nullable_to_non_nullable
              as List<SongStructure>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SongKeyCopyWith<$Res>? get songKey {
    if (_value.songKey == null) {
      return null;
    }

    return $SongKeyCopyWith<$Res>(_value.songKey!, (value) {
      return _then(_value.copyWith(songKey: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SongConfigurationImplCopyWith<$Res>
    implements $SongConfigurationCopyWith<$Res> {
  factory _$$SongConfigurationImplCopyWith(_$SongConfigurationImpl value,
          $Res Function(_$SongConfigurationImpl) then) =
      __$$SongConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? teamId,
      String? songId,
      SongKey? songKey,
      List<SongStructure>? structure});

  @override
  $SongKeyCopyWith<$Res>? get songKey;
}

/// @nodoc
class __$$SongConfigurationImplCopyWithImpl<$Res>
    extends _$SongConfigurationCopyWithImpl<$Res, _$SongConfigurationImpl>
    implements _$$SongConfigurationImplCopyWith<$Res> {
  __$$SongConfigurationImplCopyWithImpl(_$SongConfigurationImpl _value,
      $Res Function(_$SongConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamId = freezed,
    Object? songId = freezed,
    Object? songKey = freezed,
    Object? structure = freezed,
  }) {
    return _then(_$SongConfigurationImpl(
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      songId: freezed == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String?,
      songKey: freezed == songKey
          ? _value.songKey
          : songKey // ignore: cast_nullable_to_non_nullable
              as SongKey?,
      structure: freezed == structure
          ? _value._structure
          : structure // ignore: cast_nullable_to_non_nullable
              as List<SongStructure>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongConfigurationImpl implements _SongConfiguration {
  const _$SongConfigurationImpl(
      {this.teamId,
      this.songId,
      this.songKey,
      final List<SongStructure>? structure})
      : _structure = structure;

  factory _$SongConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongConfigurationImplFromJson(json);

  @override
  final String? teamId;
  @override
  final String? songId;
  @override
  final SongKey? songKey;
  final List<SongStructure>? _structure;
  @override
  List<SongStructure>? get structure {
    final value = _structure;
    if (value == null) return null;
    if (_structure is EqualUnmodifiableListView) return _structure;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SongConfiguration(teamId: $teamId, songId: $songId, songKey: $songKey, structure: $structure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongConfigurationImpl &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.songId, songId) || other.songId == songId) &&
            (identical(other.songKey, songKey) || other.songKey == songKey) &&
            const DeepCollectionEquality()
                .equals(other._structure, _structure));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, teamId, songId, songKey,
      const DeepCollectionEquality().hash(_structure));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongConfigurationImplCopyWith<_$SongConfigurationImpl> get copyWith =>
      __$$SongConfigurationImplCopyWithImpl<_$SongConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongConfigurationImplToJson(
      this,
    );
  }
}

abstract class _SongConfiguration implements SongConfiguration {
  const factory _SongConfiguration(
      {final String? teamId,
      final String? songId,
      final SongKey? songKey,
      final List<SongStructure>? structure}) = _$SongConfigurationImpl;

  factory _SongConfiguration.fromJson(Map<String, dynamic> json) =
      _$SongConfigurationImpl.fromJson;

  @override
  String? get teamId;
  @override
  String? get songId;
  @override
  SongKey? get songKey;
  @override
  List<SongStructure>? get structure;
  @override
  @JsonKey(ignore: true)
  _$$SongConfigurationImplCopyWith<_$SongConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
