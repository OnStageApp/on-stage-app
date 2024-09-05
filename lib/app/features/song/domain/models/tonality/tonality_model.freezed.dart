// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tonality_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongKey _$SongKeyFromJson(Map<String, dynamic> json) {
  return _SongKey.fromJson(json);
}

/// @nodoc
mixin _$SongKey {
  String? get name => throw _privateConstructorUsedError;
  ChordsEnum? get chord => throw _privateConstructorUsedError;
  bool? get isSharp => throw _privateConstructorUsedError;
  bool? get isMajor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongKeyCopyWith<SongKey> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongKeyCopyWith<$Res> {
  factory $SongKeyCopyWith(SongKey value, $Res Function(SongKey) then) =
      _$SongKeyCopyWithImpl<$Res, SongKey>;
  @useResult
  $Res call({String? name, ChordsEnum? chord, bool? isSharp, bool? isMajor});
}

/// @nodoc
class _$SongKeyCopyWithImpl<$Res, $Val extends SongKey>
    implements $SongKeyCopyWith<$Res> {
  _$SongKeyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? chord = freezed,
    Object? isSharp = freezed,
    Object? isMajor = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      chord: freezed == chord
          ? _value.chord
          : chord // ignore: cast_nullable_to_non_nullable
              as ChordsEnum?,
      isSharp: freezed == isSharp
          ? _value.isSharp
          : isSharp // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMajor: freezed == isMajor
          ? _value.isMajor
          : isMajor // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongKeyImplCopyWith<$Res> implements $SongKeyCopyWith<$Res> {
  factory _$$SongKeyImplCopyWith(
          _$SongKeyImpl value, $Res Function(_$SongKeyImpl) then) =
      __$$SongKeyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, ChordsEnum? chord, bool? isSharp, bool? isMajor});
}

/// @nodoc
class __$$SongKeyImplCopyWithImpl<$Res>
    extends _$SongKeyCopyWithImpl<$Res, _$SongKeyImpl>
    implements _$$SongKeyImplCopyWith<$Res> {
  __$$SongKeyImplCopyWithImpl(
      _$SongKeyImpl _value, $Res Function(_$SongKeyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? chord = freezed,
    Object? isSharp = freezed,
    Object? isMajor = freezed,
  }) {
    return _then(_$SongKeyImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      chord: freezed == chord
          ? _value.chord
          : chord // ignore: cast_nullable_to_non_nullable
              as ChordsEnum?,
      isSharp: freezed == isSharp
          ? _value.isSharp
          : isSharp // ignore: cast_nullable_to_non_nullable
              as bool?,
      isMajor: freezed == isMajor
          ? _value.isMajor
          : isMajor // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongKeyImpl implements _SongKey {
  const _$SongKeyImpl({this.name, this.chord, this.isSharp, this.isMajor});

  factory _$SongKeyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongKeyImplFromJson(json);

  @override
  final String? name;
  @override
  final ChordsEnum? chord;
  @override
  final bool? isSharp;
  @override
  final bool? isMajor;

  @override
  String toString() {
    return 'SongKey(name: $name, chord: $chord, isSharp: $isSharp, isMajor: $isMajor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongKeyImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chord, chord) || other.chord == chord) &&
            (identical(other.isSharp, isSharp) || other.isSharp == isSharp) &&
            (identical(other.isMajor, isMajor) || other.isMajor == isMajor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, chord, isSharp, isMajor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongKeyImplCopyWith<_$SongKeyImpl> get copyWith =>
      __$$SongKeyImplCopyWithImpl<_$SongKeyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongKeyImplToJson(
      this,
    );
  }
}

abstract class _SongKey implements SongKey {
  const factory _SongKey(
      {final String? name,
      final ChordsEnum? chord,
      final bool? isSharp,
      final bool? isMajor}) = _$SongKeyImpl;

  factory _SongKey.fromJson(Map<String, dynamic> json) = _$SongKeyImpl.fromJson;

  @override
  String? get name;
  @override
  ChordsEnum? get chord;
  @override
  bool? get isSharp;
  @override
  bool? get isMajor;
  @override
  @JsonKey(ignore: true)
  _$$SongKeyImplCopyWith<_$SongKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
