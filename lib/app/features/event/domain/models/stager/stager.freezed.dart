// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Stager _$StagerFromJson(Map<String, dynamic> json) {
  return _Stager.fromJson(json);
}

/// @nodoc
mixin _$Stager {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get profilePicture => throw _privateConstructorUsedError;
  StagerStatusEnum? get participationStatus =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StagerCopyWith<Stager> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StagerCopyWith<$Res> {
  factory $StagerCopyWith(Stager value, $Res Function(Stager) then) =
      _$StagerCopyWithImpl<$Res, Stager>;
  @useResult
  $Res call(
      {String id,
      String? name,
      String? profilePicture,
      StagerStatusEnum? participationStatus});
}

/// @nodoc
class _$StagerCopyWithImpl<$Res, $Val extends Stager>
    implements $StagerCopyWith<$Res> {
  _$StagerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? profilePicture = freezed,
    Object? participationStatus = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      participationStatus: freezed == participationStatus
          ? _value.participationStatus
          : participationStatus // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StagerImplCopyWith<$Res> implements $StagerCopyWith<$Res> {
  factory _$$StagerImplCopyWith(
          _$StagerImpl value, $Res Function(_$StagerImpl) then) =
      __$$StagerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? name,
      String? profilePicture,
      StagerStatusEnum? participationStatus});
}

/// @nodoc
class __$$StagerImplCopyWithImpl<$Res>
    extends _$StagerCopyWithImpl<$Res, _$StagerImpl>
    implements _$$StagerImplCopyWith<$Res> {
  __$$StagerImplCopyWithImpl(
      _$StagerImpl _value, $Res Function(_$StagerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? profilePicture = freezed,
    Object? participationStatus = freezed,
  }) {
    return _then(_$StagerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      participationStatus: freezed == participationStatus
          ? _value.participationStatus
          : participationStatus // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StagerImpl implements _Stager {
  const _$StagerImpl(
      {required this.id,
      required this.name,
      required this.profilePicture,
      required this.participationStatus});

  factory _$StagerImpl.fromJson(Map<String, dynamic> json) =>
      _$$StagerImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? profilePicture;
  @override
  final StagerStatusEnum? participationStatus;

  @override
  String toString() {
    return 'Stager(id: $id, name: $name, profilePicture: $profilePicture, participationStatus: $participationStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StagerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.participationStatus, participationStatus) ||
                other.participationStatus == participationStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, profilePicture, participationStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StagerImplCopyWith<_$StagerImpl> get copyWith =>
      __$$StagerImplCopyWithImpl<_$StagerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StagerImplToJson(
      this,
    );
  }
}

abstract class _Stager implements Stager {
  const factory _Stager(
      {required final String id,
      required final String? name,
      required final String? profilePicture,
      required final StagerStatusEnum? participationStatus}) = _$StagerImpl;

  factory _Stager.fromJson(Map<String, dynamic> json) = _$StagerImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get profilePicture;
  @override
  StagerStatusEnum? get participationStatus;
  @override
  @JsonKey(ignore: true)
  _$$StagerImplCopyWith<_$StagerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
