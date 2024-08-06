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
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get picture => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  StagerStatusEnum get status => throw _privateConstructorUsedError;

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
      String firstName,
      String lastName,
      String picture,
      String email,
      String phone,
      StagerStatusEnum status});
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
    Object? firstName = null,
    Object? lastName = null,
    Object? picture = null,
    Object? email = null,
    Object? phone = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      picture: null == picture
          ? _value.picture
          : picture // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum,
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
      String firstName,
      String lastName,
      String picture,
      String email,
      String phone,
      StagerStatusEnum status});
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
    Object? firstName = null,
    Object? lastName = null,
    Object? picture = null,
    Object? email = null,
    Object? phone = null,
    Object? status = null,
  }) {
    return _then(_$StagerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      picture: null == picture
          ? _value.picture
          : picture // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StagerImpl implements _Stager {
  const _$StagerImpl(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.picture,
      required this.email,
      required this.phone,
      required this.status});

  factory _$StagerImpl.fromJson(Map<String, dynamic> json) =>
      _$$StagerImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String picture;
  @override
  final String email;
  @override
  final String phone;
  @override
  final StagerStatusEnum status;

  @override
  String toString() {
    return 'Stager(id: $id, firstName: $firstName, lastName: $lastName, picture: $picture, email: $email, phone: $phone, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StagerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, firstName, lastName, picture, email, phone, status);

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
      required final String firstName,
      required final String lastName,
      required final String picture,
      required final String email,
      required final String phone,
      required final StagerStatusEnum status}) = _$StagerImpl;

  factory _Stager.fromJson(Map<String, dynamic> json) = _$StagerImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get picture;
  @override
  String get email;
  @override
  String get phone;
  @override
  StagerStatusEnum get status;
  @override
  @JsonKey(ignore: true)
  _$$StagerImplCopyWith<_$StagerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
