// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moments_controller_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MomentsControllerState {
  List<String> get moments => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MomentsControllerStateCopyWith<MomentsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MomentsControllerStateCopyWith<$Res> {
  factory $MomentsControllerStateCopyWith(MomentsControllerState value,
          $Res Function(MomentsControllerState) then) =
      _$MomentsControllerStateCopyWithImpl<$Res, MomentsControllerState>;
  @useResult
  $Res call({List<String> moments});
}

/// @nodoc
class _$MomentsControllerStateCopyWithImpl<$Res,
        $Val extends MomentsControllerState>
    implements $MomentsControllerStateCopyWith<$Res> {
  _$MomentsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moments = null,
  }) {
    return _then(_value.copyWith(
      moments: null == moments
          ? _value.moments
          : moments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MomentsControllerStateImplCopyWith<$Res>
    implements $MomentsControllerStateCopyWith<$Res> {
  factory _$$MomentsControllerStateImplCopyWith(
          _$MomentsControllerStateImpl value,
          $Res Function(_$MomentsControllerStateImpl) then) =
      __$$MomentsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> moments});
}

/// @nodoc
class __$$MomentsControllerStateImplCopyWithImpl<$Res>
    extends _$MomentsControllerStateCopyWithImpl<$Res,
        _$MomentsControllerStateImpl>
    implements _$$MomentsControllerStateImplCopyWith<$Res> {
  __$$MomentsControllerStateImplCopyWithImpl(
      _$MomentsControllerStateImpl _value,
      $Res Function(_$MomentsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moments = null,
  }) {
    return _then(_$MomentsControllerStateImpl(
      moments: null == moments
          ? _value._moments
          : moments // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$MomentsControllerStateImpl implements _MomentsControllerState {
  const _$MomentsControllerStateImpl({final List<String> moments = const []})
      : _moments = moments;

  final List<String> _moments;
  @override
  @JsonKey()
  List<String> get moments {
    if (_moments is EqualUnmodifiableListView) return _moments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moments);
  }

  @override
  String toString() {
    return 'MomentsControllerState(moments: $moments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MomentsControllerStateImpl &&
            const DeepCollectionEquality().equals(other._moments, _moments));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_moments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MomentsControllerStateImplCopyWith<_$MomentsControllerStateImpl>
      get copyWith => __$$MomentsControllerStateImplCopyWithImpl<
          _$MomentsControllerStateImpl>(this, _$identity);
}

abstract class _MomentsControllerState implements MomentsControllerState {
  const factory _MomentsControllerState({final List<String> moments}) =
      _$MomentsControllerStateImpl;

  @override
  List<String> get moments;
  @override
  @JsonKey(ignore: true)
  _$$MomentsControllerStateImplCopyWith<_$MomentsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
