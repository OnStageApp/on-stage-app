// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StageNotification _$StageNotificationFromJson(Map<String, dynamic> json) {
  return _StageNotification.fromJson(json);
}

/// @nodoc
mixin _$StageNotification {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get friendId => throw _privateConstructorUsedError;
  String? get friendPhotoUrl => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StageNotificationCopyWith<StageNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StageNotificationCopyWith<$Res> {
  factory $StageNotificationCopyWith(
          StageNotification value, $Res Function(StageNotification) then) =
      _$StageNotificationCopyWithImpl<$Res, StageNotification>;
  @useResult
  $Res call(
      {int id,
      String title,
      String body,
      String createdAt,
      String? friendId,
      String? friendPhotoUrl,
      String? eventId});
}

/// @nodoc
class _$StageNotificationCopyWithImpl<$Res, $Val extends StageNotification>
    implements $StageNotificationCopyWith<$Res> {
  _$StageNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? friendId = freezed,
    Object? friendPhotoUrl = freezed,
    Object? eventId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: freezed == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendPhotoUrl: freezed == friendPhotoUrl
          ? _value.friendPhotoUrl
          : friendPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StageNotificationImplCopyWith<$Res>
    implements $StageNotificationCopyWith<$Res> {
  factory _$$StageNotificationImplCopyWith(_$StageNotificationImpl value,
          $Res Function(_$StageNotificationImpl) then) =
      __$$StageNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String body,
      String createdAt,
      String? friendId,
      String? friendPhotoUrl,
      String? eventId});
}

/// @nodoc
class __$$StageNotificationImplCopyWithImpl<$Res>
    extends _$StageNotificationCopyWithImpl<$Res, _$StageNotificationImpl>
    implements _$$StageNotificationImplCopyWith<$Res> {
  __$$StageNotificationImplCopyWithImpl(_$StageNotificationImpl _value,
      $Res Function(_$StageNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? createdAt = null,
    Object? friendId = freezed,
    Object? friendPhotoUrl = freezed,
    Object? eventId = freezed,
  }) {
    return _then(_$StageNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      friendId: freezed == friendId
          ? _value.friendId
          : friendId // ignore: cast_nullable_to_non_nullable
              as String?,
      friendPhotoUrl: freezed == friendPhotoUrl
          ? _value.friendPhotoUrl
          : friendPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StageNotificationImpl implements _StageNotification {
  const _$StageNotificationImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt,
      this.friendId,
      this.friendPhotoUrl,
      this.eventId});

  factory _$StageNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StageNotificationImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String createdAt;
  @override
  final String? friendId;
  @override
  final String? friendPhotoUrl;
  @override
  final String? eventId;

  @override
  String toString() {
    return 'StageNotification(id: $id, title: $title, body: $body, createdAt: $createdAt, friendId: $friendId, friendPhotoUrl: $friendPhotoUrl, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StageNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.friendPhotoUrl, friendPhotoUrl) ||
                other.friendPhotoUrl == friendPhotoUrl) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, body, createdAt,
      friendId, friendPhotoUrl, eventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StageNotificationImplCopyWith<_$StageNotificationImpl> get copyWith =>
      __$$StageNotificationImplCopyWithImpl<_$StageNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StageNotificationImplToJson(
      this,
    );
  }
}

abstract class _StageNotification implements StageNotification {
  const factory _StageNotification(
      {required final int id,
      required final String title,
      required final String body,
      required final String createdAt,
      final String? friendId,
      final String? friendPhotoUrl,
      final String? eventId}) = _$StageNotificationImpl;

  factory _StageNotification.fromJson(Map<String, dynamic> json) =
      _$StageNotificationImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String get createdAt;
  @override
  String? get friendId;
  @override
  String? get friendPhotoUrl;
  @override
  String? get eventId;
  @override
  @JsonKey(ignore: true)
  _$$StageNotificationImplCopyWith<_$StageNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
