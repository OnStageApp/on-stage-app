// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stager_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StagerOverview _$StagerOverviewFromJson(Map<String, dynamic> json) {
  return _StagerOverview.fromJson(json);
}

/// @nodoc
mixin _$StagerOverview {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get picture => throw _privateConstructorUsedError;
  StagerStatusEnum get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StagerOverviewCopyWith<StagerOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StagerOverviewCopyWith<$Res> {
  factory $StagerOverviewCopyWith(
          StagerOverview value, $Res Function(StagerOverview) then) =
      _$StagerOverviewCopyWithImpl<$Res, StagerOverview>;
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String picture,
      StagerStatusEnum status});
}

/// @nodoc
class _$StagerOverviewCopyWithImpl<$Res, $Val extends StagerOverview>
    implements $StagerOverviewCopyWith<$Res> {
  _$StagerOverviewCopyWithImpl(this._value, this._then);

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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StagerOverviewImplCopyWith<$Res>
    implements $StagerOverviewCopyWith<$Res> {
  factory _$$StagerOverviewImplCopyWith(_$StagerOverviewImpl value,
          $Res Function(_$StagerOverviewImpl) then) =
      __$$StagerOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String firstName,
      String lastName,
      String picture,
      StagerStatusEnum status});
}

/// @nodoc
class __$$StagerOverviewImplCopyWithImpl<$Res>
    extends _$StagerOverviewCopyWithImpl<$Res, _$StagerOverviewImpl>
    implements _$$StagerOverviewImplCopyWith<$Res> {
  __$$StagerOverviewImplCopyWithImpl(
      _$StagerOverviewImpl _value, $Res Function(_$StagerOverviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? picture = null,
    Object? status = null,
  }) {
    return _then(_$StagerOverviewImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StagerStatusEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StagerOverviewImpl implements _StagerOverview {
  const _$StagerOverviewImpl(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.picture,
      required this.status});

  factory _$StagerOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$StagerOverviewImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String picture;
  @override
  final StagerStatusEnum status;

  @override
  String toString() {
    return 'StagerOverview(id: $id, firstName: $firstName, lastName: $lastName, picture: $picture, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StagerOverviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, firstName, lastName, picture, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StagerOverviewImplCopyWith<_$StagerOverviewImpl> get copyWith =>
      __$$StagerOverviewImplCopyWithImpl<_$StagerOverviewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StagerOverviewImplToJson(
      this,
    );
  }
}

abstract class _StagerOverview implements StagerOverview {
  const factory _StagerOverview(
      {required final String id,
      required final String firstName,
      required final String lastName,
      required final String picture,
      required final StagerStatusEnum status}) = _$StagerOverviewImpl;

  factory _StagerOverview.fromJson(Map<String, dynamic> json) =
      _$StagerOverviewImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get picture;
  @override
  StagerStatusEnum get status;
  @override
  @JsonKey(ignore: true)
  _$$StagerOverviewImplCopyWith<_$StagerOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
