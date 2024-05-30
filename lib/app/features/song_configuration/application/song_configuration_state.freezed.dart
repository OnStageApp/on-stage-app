// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_configuration_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SongConfigurationState {
  SongConfiguration? get songConfiguration =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongConfigurationStateCopyWith<SongConfigurationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongConfigurationStateCopyWith<$Res> {
  factory $SongConfigurationStateCopyWith(SongConfigurationState value,
          $Res Function(SongConfigurationState) then) =
      _$SongConfigurationStateCopyWithImpl<$Res, SongConfigurationState>;
  @useResult
  $Res call({SongConfiguration? songConfiguration});

  $SongConfigurationCopyWith<$Res>? get songConfiguration;
}

/// @nodoc
class _$SongConfigurationStateCopyWithImpl<$Res,
        $Val extends SongConfigurationState>
    implements $SongConfigurationStateCopyWith<$Res> {
  _$SongConfigurationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songConfiguration = freezed,
  }) {
    return _then(_value.copyWith(
      songConfiguration: freezed == songConfiguration
          ? _value.songConfiguration
          : songConfiguration // ignore: cast_nullable_to_non_nullable
              as SongConfiguration?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SongConfigurationCopyWith<$Res>? get songConfiguration {
    if (_value.songConfiguration == null) {
      return null;
    }

    return $SongConfigurationCopyWith<$Res>(_value.songConfiguration!, (value) {
      return _then(_value.copyWith(songConfiguration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SongConfigurationStateImplCopyWith<$Res>
    implements $SongConfigurationStateCopyWith<$Res> {
  factory _$$SongConfigurationStateImplCopyWith(
          _$SongConfigurationStateImpl value,
          $Res Function(_$SongConfigurationStateImpl) then) =
      __$$SongConfigurationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SongConfiguration? songConfiguration});

  @override
  $SongConfigurationCopyWith<$Res>? get songConfiguration;
}

/// @nodoc
class __$$SongConfigurationStateImplCopyWithImpl<$Res>
    extends _$SongConfigurationStateCopyWithImpl<$Res,
        _$SongConfigurationStateImpl>
    implements _$$SongConfigurationStateImplCopyWith<$Res> {
  __$$SongConfigurationStateImplCopyWithImpl(
      _$SongConfigurationStateImpl _value,
      $Res Function(_$SongConfigurationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songConfiguration = freezed,
  }) {
    return _then(_$SongConfigurationStateImpl(
      songConfiguration: freezed == songConfiguration
          ? _value.songConfiguration
          : songConfiguration // ignore: cast_nullable_to_non_nullable
              as SongConfiguration?,
    ));
  }
}

/// @nodoc

class _$SongConfigurationStateImpl implements _SongConfigurationState {
  const _$SongConfigurationStateImpl({this.songConfiguration});

  @override
  final SongConfiguration? songConfiguration;

  @override
  String toString() {
    return 'SongConfigurationState(songConfiguration: $songConfiguration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongConfigurationStateImpl &&
            (identical(other.songConfiguration, songConfiguration) ||
                other.songConfiguration == songConfiguration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, songConfiguration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongConfigurationStateImplCopyWith<_$SongConfigurationStateImpl>
      get copyWith => __$$SongConfigurationStateImplCopyWithImpl<
          _$SongConfigurationStateImpl>(this, _$identity);
}

abstract class _SongConfigurationState implements SongConfigurationState {
  const factory _SongConfigurationState(
          {final SongConfiguration? songConfiguration}) =
      _$SongConfigurationStateImpl;

  @override
  SongConfiguration? get songConfiguration;
  @override
  @JsonKey(ignore: true)
  _$$SongConfigurationStateImplCopyWith<_$SongConfigurationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
