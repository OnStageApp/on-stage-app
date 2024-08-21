// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventOverview _$EventOverviewFromJson(Map<String, dynamic> json) {
  return _EventOverview.fromJson(json);
}

/// @nodoc
mixin _$EventOverview {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventOverviewCopyWith<EventOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventOverviewCopyWith<$Res> {
  factory $EventOverviewCopyWith(
          EventOverview value, $Res Function(EventOverview) then) =
      _$EventOverviewCopyWithImpl<$Res, EventOverview>;
  @useResult
  $Res call({String id, String? name, String? date});
}

/// @nodoc
class _$EventOverviewCopyWithImpl<$Res, $Val extends EventOverview>
    implements $EventOverviewCopyWith<$Res> {
  _$EventOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? date = freezed,
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
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventOverviewImplCopyWith<$Res>
    implements $EventOverviewCopyWith<$Res> {
  factory _$$EventOverviewImplCopyWith(
          _$EventOverviewImpl value, $Res Function(_$EventOverviewImpl) then) =
      __$$EventOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, String? date});
}

/// @nodoc
class __$$EventOverviewImplCopyWithImpl<$Res>
    extends _$EventOverviewCopyWithImpl<$Res, _$EventOverviewImpl>
    implements _$$EventOverviewImplCopyWith<$Res> {
  __$$EventOverviewImplCopyWithImpl(
      _$EventOverviewImpl _value, $Res Function(_$EventOverviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? date = freezed,
  }) {
    return _then(_$EventOverviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventOverviewImpl implements _EventOverview {
  const _$EventOverviewImpl(
      {required this.id, required this.name, required this.date});

  factory _$EventOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventOverviewImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? date;

  @override
  String toString() {
    return 'EventOverview(id: $id, name: $name, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventOverviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventOverviewImplCopyWith<_$EventOverviewImpl> get copyWith =>
      __$$EventOverviewImplCopyWithImpl<_$EventOverviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventOverviewImplToJson(
      this,
    );
  }
}

abstract class _EventOverview implements EventOverview {
  const factory _EventOverview(
      {required final String id,
      required final String? name,
      required final String? date}) = _$EventOverviewImpl;

  factory _EventOverview.fromJson(Map<String, dynamic> json) =
      _$EventOverviewImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get date;
  @override
  @JsonKey(ignore: true)
  _$$EventOverviewImplCopyWith<_$EventOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
