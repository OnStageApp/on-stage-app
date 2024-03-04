// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<DateTime>? get rehearsalDates => throw _privateConstructorUsedError;
  List<EventItem>? get eventItems => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime date,
      List<DateTime>? rehearsalDates,
      List<EventItem>? eventItems,
      String location});
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? rehearsalDates = freezed,
    Object? eventItems = freezed,
    Object? location = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rehearsalDates: freezed == rehearsalDates
          ? _value.rehearsalDates
          : rehearsalDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>?,
      eventItems: freezed == eventItems
          ? _value.eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItem>?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventModelCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime date,
      List<DateTime>? rehearsalDates,
      List<EventItem>? eventItems,
      String location});
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? rehearsalDates = freezed,
    Object? eventItems = freezed,
    Object? location = null,
  }) {
    return _then(_$EventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rehearsalDates: freezed == rehearsalDates
          ? _value._rehearsalDates
          : rehearsalDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>?,
      eventItems: freezed == eventItems
          ? _value._eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItem>?,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl implements _Event {
  const _$EventImpl(
      {required this.id,
      required this.name,
      required this.date,
      required final List<DateTime>? rehearsalDates,
      required final List<EventItem>? eventItems,
      required this.location})
      : _rehearsalDates = rehearsalDates,
        _eventItems = eventItems;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime date;
  final List<DateTime>? _rehearsalDates;
  @override
  List<DateTime>? get rehearsalDates {
    final value = _rehearsalDates;
    if (value == null) return null;
    if (_rehearsalDates is EqualUnmodifiableListView) return _rehearsalDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<EventItem>? _eventItems;
  @override
  List<EventItem>? get eventItems {
    final value = _eventItems;
    if (value == null) return null;
    if (_eventItems is EqualUnmodifiableListView) return _eventItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String location;

  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, date: $date, rehearsalDates: $rehearsalDates, eventItems: $eventItems, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._rehearsalDates, _rehearsalDates) &&
            const DeepCollectionEquality()
                .equals(other._eventItems, _eventItems) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      date,
      const DeepCollectionEquality().hash(_rehearsalDates),
      const DeepCollectionEquality().hash(_eventItems),
      location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event implements EventModel {
  const factory _Event(
      {required final String id,
      required final String name,
      required final DateTime date,
      required final List<DateTime>? rehearsalDates,
      required final List<EventItem>? eventItems,
      required final String location}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get date;
  @override
  List<DateTime>? get rehearsalDates;
  @override
  List<EventItem>? get eventItems;
  @override
  String get location;
  @override
  @JsonKey(ignore: true)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
