// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_items_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventItemsRequest _$EventItemsRequestFromJson(Map<String, dynamic> json) {
  return _EventItemsRequest.fromJson(json);
}

/// @nodoc
mixin _$EventItemsRequest {
  List<EventItemCreate> get eventItems => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventItemsRequestCopyWith<EventItemsRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventItemsRequestCopyWith<$Res> {
  factory $EventItemsRequestCopyWith(
          EventItemsRequest value, $Res Function(EventItemsRequest) then) =
      _$EventItemsRequestCopyWithImpl<$Res, EventItemsRequest>;
  @useResult
  $Res call({List<EventItemCreate> eventItems, String eventId});
}

/// @nodoc
class _$EventItemsRequestCopyWithImpl<$Res, $Val extends EventItemsRequest>
    implements $EventItemsRequestCopyWith<$Res> {
  _$EventItemsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventItems = null,
    Object? eventId = null,
  }) {
    return _then(_value.copyWith(
      eventItems: null == eventItems
          ? _value.eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItemCreate>,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventItemsRequestImplCopyWith<$Res>
    implements $EventItemsRequestCopyWith<$Res> {
  factory _$$EventItemsRequestImplCopyWith(_$EventItemsRequestImpl value,
          $Res Function(_$EventItemsRequestImpl) then) =
      __$$EventItemsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EventItemCreate> eventItems, String eventId});
}

/// @nodoc
class __$$EventItemsRequestImplCopyWithImpl<$Res>
    extends _$EventItemsRequestCopyWithImpl<$Res, _$EventItemsRequestImpl>
    implements _$$EventItemsRequestImplCopyWith<$Res> {
  __$$EventItemsRequestImplCopyWithImpl(_$EventItemsRequestImpl _value,
      $Res Function(_$EventItemsRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventItems = null,
    Object? eventId = null,
  }) {
    return _then(_$EventItemsRequestImpl(
      eventItems: null == eventItems
          ? _value._eventItems
          : eventItems // ignore: cast_nullable_to_non_nullable
              as List<EventItemCreate>,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventItemsRequestImpl implements _EventItemsRequest {
  const _$EventItemsRequestImpl(
      {required final List<EventItemCreate> eventItems, required this.eventId})
      : _eventItems = eventItems;

  factory _$EventItemsRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventItemsRequestImplFromJson(json);

  final List<EventItemCreate> _eventItems;
  @override
  List<EventItemCreate> get eventItems {
    if (_eventItems is EqualUnmodifiableListView) return _eventItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventItems);
  }

  @override
  final String eventId;

  @override
  String toString() {
    return 'EventItemsRequest(eventItems: $eventItems, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventItemsRequestImpl &&
            const DeepCollectionEquality()
                .equals(other._eventItems, _eventItems) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_eventItems), eventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventItemsRequestImplCopyWith<_$EventItemsRequestImpl> get copyWith =>
      __$$EventItemsRequestImplCopyWithImpl<_$EventItemsRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventItemsRequestImplToJson(
      this,
    );
  }
}

abstract class _EventItemsRequest implements EventItemsRequest {
  const factory _EventItemsRequest(
      {required final List<EventItemCreate> eventItems,
      required final String eventId}) = _$EventItemsRequestImpl;

  factory _EventItemsRequest.fromJson(Map<String, dynamic> json) =
      _$EventItemsRequestImpl.fromJson;

  @override
  List<EventItemCreate> get eventItems;
  @override
  String get eventId;
  @override
  @JsonKey(ignore: true)
  _$$EventItemsRequestImplCopyWith<_$EventItemsRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
