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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  List<String> get rehearsalsDate => throw _privateConstructorUsedError;
  List<String> get staggersId => throw _privateConstructorUsedError;
  List<String> get adminsId => throw _privateConstructorUsedError;
  List<String> get eventItemIds => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

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
      String date,
      List<String> rehearsalsDate,
      List<String> staggersId,
      List<String> adminsId,
      List<String> eventItemIds,
      String location,
      String? imageUrl});
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
    Object? rehearsalsDate = null,
    Object? staggersId = null,
    Object? adminsId = null,
    Object? eventItemIds = null,
    Object? location = null,
    Object? imageUrl = freezed,
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
              as String,
      rehearsalsDate: null == rehearsalsDate
          ? _value.rehearsalsDate
          : rehearsalsDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      staggersId: null == staggersId
          ? _value.staggersId
          : staggersId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminsId: null == adminsId
          ? _value.adminsId
          : adminsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventItemIds: null == eventItemIds
          ? _value.eventItemIds
          : eventItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      String date,
      List<String> rehearsalsDate,
      List<String> staggersId,
      List<String> adminsId,
      List<String> eventItemIds,
      String location,
      String? imageUrl});
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
    Object? rehearsalsDate = null,
    Object? staggersId = null,
    Object? adminsId = null,
    Object? eventItemIds = null,
    Object? location = null,
    Object? imageUrl = freezed,
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
              as String,
      rehearsalsDate: null == rehearsalsDate
          ? _value._rehearsalsDate
          : rehearsalsDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      staggersId: null == staggersId
          ? _value._staggersId
          : staggersId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adminsId: null == adminsId
          ? _value._adminsId
          : adminsId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      eventItemIds: null == eventItemIds
          ? _value._eventItemIds
          : eventItemIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
      required final List<String> rehearsalsDate,
      required final List<String> staggersId,
      required final List<String> adminsId,
      required final List<String> eventItemIds,
      required this.location,
      this.imageUrl})
      : _rehearsalsDate = rehearsalsDate,
        _staggersId = staggersId,
        _adminsId = adminsId,
        _eventItemIds = eventItemIds;

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String date;
  final List<String> _rehearsalsDate;
  @override
  List<String> get rehearsalsDate {
    if (_rehearsalsDate is EqualUnmodifiableListView) return _rehearsalsDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rehearsalsDate);
  }

  final List<String> _staggersId;
  @override
  List<String> get staggersId {
    if (_staggersId is EqualUnmodifiableListView) return _staggersId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staggersId);
  }

  final List<String> _adminsId;
  @override
  List<String> get adminsId {
    if (_adminsId is EqualUnmodifiableListView) return _adminsId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adminsId);
  }

  final List<String> _eventItemIds;
  @override
  List<String> get eventItemIds {
    if (_eventItemIds is EqualUnmodifiableListView) return _eventItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventItemIds);
  }

  @override
  final String location;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, date: $date, rehearsalsDate: $rehearsalsDate, staggersId: $staggersId, adminsId: $adminsId, eventItemIds: $eventItemIds, location: $location, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._rehearsalsDate, _rehearsalsDate) &&
            const DeepCollectionEquality()
                .equals(other._staggersId, _staggersId) &&
            const DeepCollectionEquality().equals(other._adminsId, _adminsId) &&
            const DeepCollectionEquality()
                .equals(other._eventItemIds, _eventItemIds) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      date,
      const DeepCollectionEquality().hash(_rehearsalsDate),
      const DeepCollectionEquality().hash(_staggersId),
      const DeepCollectionEquality().hash(_adminsId),
      const DeepCollectionEquality().hash(_eventItemIds),
      location,
      imageUrl);

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
      required final String date,
      required final List<String> rehearsalsDate,
      required final List<String> staggersId,
      required final List<String> adminsId,
      required final List<String> eventItemIds,
      required final String location,
      final String? imageUrl}) = _$EventImpl;

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get date;
  @override
  List<String> get rehearsalsDate;
  @override
  List<String> get staggersId;
  @override
  List<String> get adminsId;
  @override
  List<String> get eventItemIds;
  @override
  String get location;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
