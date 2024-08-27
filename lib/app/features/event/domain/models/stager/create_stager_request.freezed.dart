// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_stager_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateStagerRequest _$CreateStagerRequestFromJson(Map<String, dynamic> json) {
  return _CreateStagerRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateStagerRequest {
  List<String> get userIds => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateStagerRequestCopyWith<CreateStagerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateStagerRequestCopyWith<$Res> {
  factory $CreateStagerRequestCopyWith(
          CreateStagerRequest value, $Res Function(CreateStagerRequest) then) =
      _$CreateStagerRequestCopyWithImpl<$Res, CreateStagerRequest>;
  @useResult
  $Res call({List<String> userIds, String eventId});
}

/// @nodoc
class _$CreateStagerRequestCopyWithImpl<$Res, $Val extends CreateStagerRequest>
    implements $CreateStagerRequestCopyWith<$Res> {
  _$CreateStagerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userIds = null,
    Object? eventId = null,
  }) {
    return _then(_value.copyWith(
      userIds: null == userIds
          ? _value.userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateStagerRequestImplCopyWith<$Res>
    implements $CreateStagerRequestCopyWith<$Res> {
  factory _$$CreateStagerRequestImplCopyWith(_$CreateStagerRequestImpl value,
          $Res Function(_$CreateStagerRequestImpl) then) =
      __$$CreateStagerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> userIds, String eventId});
}

/// @nodoc
class __$$CreateStagerRequestImplCopyWithImpl<$Res>
    extends _$CreateStagerRequestCopyWithImpl<$Res, _$CreateStagerRequestImpl>
    implements _$$CreateStagerRequestImplCopyWith<$Res> {
  __$$CreateStagerRequestImplCopyWithImpl(_$CreateStagerRequestImpl _value,
      $Res Function(_$CreateStagerRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userIds = null,
    Object? eventId = null,
  }) {
    return _then(_$CreateStagerRequestImpl(
      userIds: null == userIds
          ? _value._userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateStagerRequestImpl implements _CreateStagerRequest {
  const _$CreateStagerRequestImpl(
      {required final List<String> userIds, required this.eventId})
      : _userIds = userIds;

  factory _$CreateStagerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateStagerRequestImplFromJson(json);

  final List<String> _userIds;
  @override
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  @override
  final String eventId;

  @override
  String toString() {
    return 'CreateStagerRequest(userIds: $userIds, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateStagerRequestImpl &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_userIds), eventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateStagerRequestImplCopyWith<_$CreateStagerRequestImpl> get copyWith =>
      __$$CreateStagerRequestImplCopyWithImpl<_$CreateStagerRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateStagerRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateStagerRequest implements CreateStagerRequest {
  const factory _CreateStagerRequest(
      {required final List<String> userIds,
      required final String eventId}) = _$CreateStagerRequestImpl;

  factory _CreateStagerRequest.fromJson(Map<String, dynamic> json) =
      _$CreateStagerRequestImpl.fromJson;

  @override
  List<String> get userIds;
  @override
  String get eventId;
  @override
  @JsonKey(ignore: true)
  _$$CreateStagerRequestImplCopyWith<_$CreateStagerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
