// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_item_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventItemCreate _$EventItemCreateFromJson(Map<String, dynamic> json) {
  return _EventItemCreate.fromJson(json);
}

/// @nodoc
mixin _$EventItemCreate {
  String? get name => throw _privateConstructorUsedError;
  int? get index => throw _privateConstructorUsedError;
  String? get songId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventItemCreateCopyWith<EventItemCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventItemCreateCopyWith<$Res> {
  factory $EventItemCreateCopyWith(
          EventItemCreate value, $Res Function(EventItemCreate) then) =
      _$EventItemCreateCopyWithImpl<$Res, EventItemCreate>;
  @useResult
  $Res call({String? name, int? index, String? songId});
}

/// @nodoc
class _$EventItemCreateCopyWithImpl<$Res, $Val extends EventItemCreate>
    implements $EventItemCreateCopyWith<$Res> {
  _$EventItemCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? index = freezed,
    Object? songId = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int?,
      songId: freezed == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventItemCreateImplCopyWith<$Res>
    implements $EventItemCreateCopyWith<$Res> {
  factory _$$EventItemCreateImplCopyWith(_$EventItemCreateImpl value,
          $Res Function(_$EventItemCreateImpl) then) =
      __$$EventItemCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? index, String? songId});
}

/// @nodoc
class __$$EventItemCreateImplCopyWithImpl<$Res>
    extends _$EventItemCreateCopyWithImpl<$Res, _$EventItemCreateImpl>
    implements _$$EventItemCreateImplCopyWith<$Res> {
  __$$EventItemCreateImplCopyWithImpl(
      _$EventItemCreateImpl _value, $Res Function(_$EventItemCreateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? index = freezed,
    Object? songId = freezed,
  }) {
    return _then(_$EventItemCreateImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int?,
      songId: freezed == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventItemCreateImpl extends _EventItemCreate {
  const _$EventItemCreateImpl(
      {required this.name, required this.index, this.songId})
      : super._();

  factory _$EventItemCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventItemCreateImplFromJson(json);

  @override
  final String? name;
  @override
  final int? index;
  @override
  final String? songId;

  @override
  String toString() {
    return 'EventItemCreate(name: $name, index: $index, songId: $songId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventItemCreateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.songId, songId) || other.songId == songId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, index, songId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventItemCreateImplCopyWith<_$EventItemCreateImpl> get copyWith =>
      __$$EventItemCreateImplCopyWithImpl<_$EventItemCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventItemCreateImplToJson(
      this,
    );
  }
}

abstract class _EventItemCreate extends EventItemCreate {
  const factory _EventItemCreate(
      {required final String? name,
      required final int? index,
      final String? songId}) = _$EventItemCreateImpl;
  const _EventItemCreate._() : super._();

  factory _EventItemCreate.fromJson(Map<String, dynamic> json) =
      _$EventItemCreateImpl.fromJson;

  @override
  String? get name;
  @override
  int? get index;
  @override
  String? get songId;
  @override
  @JsonKey(ignore: true)
  _$$EventItemCreateImplCopyWith<_$EventItemCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
