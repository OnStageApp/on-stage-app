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

RehearsalModel _$RehearsalModelFromJson(Map<String, dynamic> json) {
  return _RehearsalModel.fromJson(json);
}

/// @nodoc
mixin _$RehearsalModel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime? get dateTime => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RehearsalModelCopyWith<RehearsalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RehearsalModelCopyWith<$Res> {
  factory $RehearsalModelCopyWith(
          RehearsalModel value, $Res Function(RehearsalModel) then) =
      _$RehearsalModelCopyWithImpl<$Res, RehearsalModel>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? location,
      DateTime? dateTime,
      String? eventId});
}

/// @nodoc
class _$RehearsalModelCopyWithImpl<$Res, $Val extends RehearsalModel>
    implements $RehearsalModelCopyWith<$Res> {
  _$RehearsalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? location = freezed,
    Object? dateTime = freezed,
    Object? eventId = freezed,
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
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RehearsalModelImplCopyWith<$Res>
    implements $RehearsalModelCopyWith<$Res> {
  factory _$$RehearsalModelImplCopyWith(_$RehearsalModelImpl value,
          $Res Function(_$RehearsalModelImpl) then) =
      __$$RehearsalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? location,
      DateTime? dateTime,
      String? eventId});
}

/// @nodoc
class __$$RehearsalModelImplCopyWithImpl<$Res>
    extends _$RehearsalModelCopyWithImpl<$Res, _$RehearsalModelImpl>
    implements _$$RehearsalModelImplCopyWith<$Res> {
  __$$RehearsalModelImplCopyWithImpl(
      _$RehearsalModelImpl _value, $Res Function(_$RehearsalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? location = freezed,
    Object? dateTime = freezed,
    Object? eventId = freezed,
  }) {
    return _then(_$RehearsalModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      dateTime: freezed == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RehearsalModelImpl implements _RehearsalModel {
  const _$RehearsalModelImpl(
      {this.id, this.name, this.location, this.dateTime, this.eventId});

  factory _$RehearsalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RehearsalModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? location;
  @override
  final DateTime? dateTime;
  @override
  final String? eventId;

  @override
  String toString() {
    return 'RehearsalModel(id: $id, name: $name, location: $location, dateTime: $dateTime, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RehearsalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, location, dateTime, eventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RehearsalModelImplCopyWith<_$RehearsalModelImpl> get copyWith =>
      __$$RehearsalModelImplCopyWithImpl<_$RehearsalModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RehearsalModelImplToJson(
      this,
    );
  }
}

abstract class _RehearsalModel implements RehearsalModel {
  const factory _RehearsalModel(
      {final String? id,
      final String? name,
      final String? location,
      final DateTime? dateTime,
      final String? eventId}) = _$RehearsalModelImpl;

  factory _RehearsalModel.fromJson(Map<String, dynamic> json) =
      _$RehearsalModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get location;
  @override
  DateTime? get dateTime;
  @override
  String? get eventId;
  @override
  @JsonKey(ignore: true)
  _$$RehearsalModelImplCopyWith<_$RehearsalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
