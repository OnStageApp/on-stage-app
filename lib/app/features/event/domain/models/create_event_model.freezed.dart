// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateEventModel _$CreateEventModelFromJson(Map<String, dynamic> json) {
  return _CreateEventModel.fromJson(json);
}

/// @nodoc
mixin _$CreateEventModel {
  String get name => throw _privateConstructorUsedError;
  DateTime? get dateTime => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  EventStatus get eventStatus => throw _privateConstructorUsedError;
  List<String> get userIds => throw _privateConstructorUsedError;
  List<RehearsalModel> get rehearsals => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateEventModelCopyWith<CreateEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateEventModelCopyWith<$Res> {
  factory $CreateEventModelCopyWith(
          CreateEventModel value, $Res Function(CreateEventModel) then) =
      _$CreateEventModelCopyWithImpl<$Res, CreateEventModel>;
  @useResult
  $Res call(
      {String name,
      DateTime? dateTime,
      String location,
      EventStatus eventStatus,
      List<String> userIds,
      List<RehearsalModel> rehearsals});
}

/// @nodoc
class _$CreateEventModelCopyWithImpl<$Res, $Val extends CreateEventModel>
    implements $CreateEventModelCopyWith<$Res> {
  _$CreateEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dateTime = freezed,
    Object? location = null,
    Object? eventStatus = null,
    Object? userIds = null,
    Object? rehearsals = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      eventStatus: null == eventStatus
          ? _value.eventStatus
          : eventStatus // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      userIds: null == userIds
          ? _value.userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rehearsals: null == rehearsals
          ? _value.rehearsals
          : rehearsals // ignore: cast_nullable_to_non_nullable
              as List<RehearsalModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateEventModelImplCopyWith<$Res>
    implements $CreateEventModelCopyWith<$Res> {
  factory _$$CreateEventModelImplCopyWith(_$CreateEventModelImpl value,
          $Res Function(_$CreateEventModelImpl) then) =
      __$$CreateEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      DateTime? dateTime,
      String location,
      EventStatus eventStatus,
      List<String> userIds,
      List<RehearsalModel> rehearsals});
}

/// @nodoc
class __$$CreateEventModelImplCopyWithImpl<$Res>
    extends _$CreateEventModelCopyWithImpl<$Res, _$CreateEventModelImpl>
    implements _$$CreateEventModelImplCopyWith<$Res> {
  __$$CreateEventModelImplCopyWithImpl(_$CreateEventModelImpl _value,
      $Res Function(_$CreateEventModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? dateTime = freezed,
    Object? location = null,
    Object? eventStatus = null,
    Object? userIds = null,
    Object? rehearsals = null,
  }) {
    return _then(_$CreateEventModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      eventStatus: null == eventStatus
          ? _value.eventStatus
          : eventStatus // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      userIds: null == userIds
          ? _value._userIds
          : userIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rehearsals: null == rehearsals
          ? _value._rehearsals
          : rehearsals // ignore: cast_nullable_to_non_nullable
              as List<RehearsalModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateEventModelImpl implements _CreateEventModel {
  const _$CreateEventModelImpl(
      {required this.name,
      required this.dateTime,
      required this.location,
      required this.eventStatus,
      required final List<String> userIds,
      required final List<RehearsalModel> rehearsals})
      : _userIds = userIds,
        _rehearsals = rehearsals;

  factory _$CreateEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateEventModelImplFromJson(json);

  @override
  final String name;
  @override
  final DateTime? dateTime;
  @override
  final String location;
  @override
  final EventStatus eventStatus;
  final List<String> _userIds;
  @override
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  final List<RehearsalModel> _rehearsals;
  @override
  List<RehearsalModel> get rehearsals {
    if (_rehearsals is EqualUnmodifiableListView) return _rehearsals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rehearsals);
  }

  @override
  String toString() {
    return 'CreateEventModel(name: $name, dateTime: $dateTime, location: $location, eventStatus: $eventStatus, userIds: $userIds, rehearsals: $rehearsals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateEventModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.eventStatus, eventStatus) ||
                other.eventStatus == eventStatus) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            const DeepCollectionEquality()
                .equals(other._rehearsals, _rehearsals));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      dateTime,
      location,
      eventStatus,
      const DeepCollectionEquality().hash(_userIds),
      const DeepCollectionEquality().hash(_rehearsals));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateEventModelImplCopyWith<_$CreateEventModelImpl> get copyWith =>
      __$$CreateEventModelImplCopyWithImpl<_$CreateEventModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateEventModelImplToJson(
      this,
    );
  }
}

abstract class _CreateEventModel implements CreateEventModel {
  const factory _CreateEventModel(
      {required final String name,
      required final DateTime? dateTime,
      required final String location,
      required final EventStatus eventStatus,
      required final List<String> userIds,
      required final List<RehearsalModel> rehearsals}) = _$CreateEventModelImpl;

  factory _CreateEventModel.fromJson(Map<String, dynamic> json) =
      _$CreateEventModelImpl.fromJson;

  @override
  String get name;
  @override
  DateTime? get dateTime;
  @override
  String get location;
  @override
  EventStatus get eventStatus;
  @override
  List<String> get userIds;
  @override
  List<RehearsalModel> get rehearsals;
  @override
  @JsonKey(ignore: true)
  _$$CreateEventModelImplCopyWith<_$CreateEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
