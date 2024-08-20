// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rehearsals_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RehearsalsState {
  List<Rehearsal> get rehearsals => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RehearsalsStateCopyWith<RehearsalsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RehearsalsStateCopyWith<$Res> {
  factory $RehearsalsStateCopyWith(
          RehearsalsState value, $Res Function(RehearsalsState) then) =
      _$RehearsalsStateCopyWithImpl<$Res, RehearsalsState>;
  @useResult
  $Res call({List<Rehearsal> rehearsals, bool isLoading});
}

/// @nodoc
class _$RehearsalsStateCopyWithImpl<$Res, $Val extends RehearsalsState>
    implements $RehearsalsStateCopyWith<$Res> {
  _$RehearsalsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rehearsals = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      rehearsals: null == rehearsals
          ? _value.rehearsals
          : rehearsals // ignore: cast_nullable_to_non_nullable
              as List<Rehearsal>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RehearsalsStateImplCopyWith<$Res>
    implements $RehearsalsStateCopyWith<$Res> {
  factory _$$RehearsalsStateImplCopyWith(_$RehearsalsStateImpl value,
          $Res Function(_$RehearsalsStateImpl) then) =
      __$$RehearsalsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Rehearsal> rehearsals, bool isLoading});
}

/// @nodoc
class __$$RehearsalsStateImplCopyWithImpl<$Res>
    extends _$RehearsalsStateCopyWithImpl<$Res, _$RehearsalsStateImpl>
    implements _$$RehearsalsStateImplCopyWith<$Res> {
  __$$RehearsalsStateImplCopyWithImpl(
      _$RehearsalsStateImpl _value, $Res Function(_$RehearsalsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rehearsals = null,
    Object? isLoading = null,
  }) {
    return _then(_$RehearsalsStateImpl(
      rehearsals: null == rehearsals
          ? _value._rehearsals
          : rehearsals // ignore: cast_nullable_to_non_nullable
              as List<Rehearsal>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RehearsalsStateImpl implements _RehearsalsState {
  const _$RehearsalsStateImpl(
      {final List<Rehearsal> rehearsals = const [], this.isLoading = false})
      : _rehearsals = rehearsals;

  final List<Rehearsal> _rehearsals;
  @override
  @JsonKey()
  List<Rehearsal> get rehearsals {
    if (_rehearsals is EqualUnmodifiableListView) return _rehearsals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rehearsals);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'RehearsalsState(rehearsals: $rehearsals, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RehearsalsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._rehearsals, _rehearsals) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_rehearsals), isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RehearsalsStateImplCopyWith<_$RehearsalsStateImpl> get copyWith =>
      __$$RehearsalsStateImplCopyWithImpl<_$RehearsalsStateImpl>(
          this, _$identity);
}

abstract class _RehearsalsState implements RehearsalsState {
  const factory _RehearsalsState(
      {final List<Rehearsal> rehearsals,
      final bool isLoading}) = _$RehearsalsStateImpl;

  @override
  List<Rehearsal> get rehearsals;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$RehearsalsStateImplCopyWith<_$RehearsalsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
