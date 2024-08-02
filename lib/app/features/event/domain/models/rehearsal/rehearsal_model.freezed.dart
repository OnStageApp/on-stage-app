// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rehearsal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Rehearsal _$RehearsalFromJson(Map<String, dynamic> json) {
  return _Rehearsal.fromJson(json);
}

/// @nodoc
mixin _$Rehearsal {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  DateTime? get dateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RehearsalCopyWith<Rehearsal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RehearsalCopyWith<$Res> {
  factory $RehearsalCopyWith(Rehearsal value, $Res Function(Rehearsal) then) =
      _$RehearsalCopyWithImpl<$Res, Rehearsal>;
  @useResult
  $Res call({String? id, String? name, DateTime? dateTime});
}

/// @nodoc
class _$RehearsalCopyWithImpl<$Res, $Val extends Rehearsal>
    implements $RehearsalCopyWith<$Res> {
  _$RehearsalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RehearsalImplCopyWith<$Res>
    implements $RehearsalCopyWith<$Res> {
  factory _$$RehearsalImplCopyWith(
          _$RehearsalImpl value, $Res Function(_$RehearsalImpl) then) =
      __$$RehearsalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, DateTime? dateTime});
}

/// @nodoc
class __$$RehearsalImplCopyWithImpl<$Res>
    extends _$RehearsalCopyWithImpl<$Res, _$RehearsalImpl>
    implements _$$RehearsalImplCopyWith<$Res> {
  __$$RehearsalImplCopyWithImpl(
      _$RehearsalImpl _value, $Res Function(_$RehearsalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? dateTime = freezed,
  }) {
    return _then(_$RehearsalImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RehearsalImpl implements _Rehearsal {
  const _$RehearsalImpl(
      {required this.id, required this.name, required this.dateTime});

  factory _$RehearsalImpl.fromJson(Map<String, dynamic> json) =>
      _$$RehearsalImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final DateTime? dateTime;

  @override
  String toString() {
    return 'Rehearsal(id: $id, name: $name, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RehearsalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, dateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RehearsalImplCopyWith<_$RehearsalImpl> get copyWith =>
      __$$RehearsalImplCopyWithImpl<_$RehearsalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RehearsalImplToJson(
      this,
    );
  }
}

abstract class _Rehearsal implements Rehearsal {
  const factory _Rehearsal(
      {required final String? id,
      required final String? name,
      required final DateTime? dateTime}) = _$RehearsalImpl;

  factory _Rehearsal.fromJson(Map<String, dynamic> json) =
      _$RehearsalImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  DateTime? get dateTime;
  @override
  @JsonKey(ignore: true)
  _$$RehearsalImplCopyWith<_$RehearsalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
