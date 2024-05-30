// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_preferences_controller_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SongPreferencesControllerState {
  bool get isOnAddStructurePage => throw _privateConstructorUsedError;
  List<Section> get songSections => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SongPreferencesControllerStateCopyWith<SongPreferencesControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongPreferencesControllerStateCopyWith<$Res> {
  factory $SongPreferencesControllerStateCopyWith(
          SongPreferencesControllerState value,
          $Res Function(SongPreferencesControllerState) then) =
      _$SongPreferencesControllerStateCopyWithImpl<$Res,
          SongPreferencesControllerState>;
  @useResult
  $Res call({bool isOnAddStructurePage, List<Section> songSections});
}

/// @nodoc
class _$SongPreferencesControllerStateCopyWithImpl<$Res,
        $Val extends SongPreferencesControllerState>
    implements $SongPreferencesControllerStateCopyWith<$Res> {
  _$SongPreferencesControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnAddStructurePage = null,
    Object? songSections = null,
  }) {
    return _then(_value.copyWith(
      isOnAddStructurePage: null == isOnAddStructurePage
          ? _value.isOnAddStructurePage
          : isOnAddStructurePage // ignore: cast_nullable_to_non_nullable
              as bool,
      songSections: null == songSections
          ? _value.songSections
          : songSections // ignore: cast_nullable_to_non_nullable
              as List<Section>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongPreferencesControllerStateImplCopyWith<$Res>
    implements $SongPreferencesControllerStateCopyWith<$Res> {
  factory _$$SongPreferencesControllerStateImplCopyWith(
          _$SongPreferencesControllerStateImpl value,
          $Res Function(_$SongPreferencesControllerStateImpl) then) =
      __$$SongPreferencesControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isOnAddStructurePage, List<Section> songSections});
}

/// @nodoc
class __$$SongPreferencesControllerStateImplCopyWithImpl<$Res>
    extends _$SongPreferencesControllerStateCopyWithImpl<$Res,
        _$SongPreferencesControllerStateImpl>
    implements _$$SongPreferencesControllerStateImplCopyWith<$Res> {
  __$$SongPreferencesControllerStateImplCopyWithImpl(
      _$SongPreferencesControllerStateImpl _value,
      $Res Function(_$SongPreferencesControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnAddStructurePage = null,
    Object? songSections = null,
  }) {
    return _then(_$SongPreferencesControllerStateImpl(
      isOnAddStructurePage: null == isOnAddStructurePage
          ? _value.isOnAddStructurePage
          : isOnAddStructurePage // ignore: cast_nullable_to_non_nullable
              as bool,
      songSections: null == songSections
          ? _value._songSections
          : songSections // ignore: cast_nullable_to_non_nullable
              as List<Section>,
    ));
  }
}

/// @nodoc

class _$SongPreferencesControllerStateImpl
    implements _SongPreferencesControllerState {
  const _$SongPreferencesControllerStateImpl(
      {this.isOnAddStructurePage = false,
      final List<Section> songSections = const []})
      : _songSections = songSections;

  @override
  @JsonKey()
  final bool isOnAddStructurePage;
  final List<Section> _songSections;
  @override
  @JsonKey()
  List<Section> get songSections {
    if (_songSections is EqualUnmodifiableListView) return _songSections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songSections);
  }

  @override
  String toString() {
    return 'SongPreferencesControllerState(isOnAddStructurePage: $isOnAddStructurePage, songSections: $songSections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongPreferencesControllerStateImpl &&
            (identical(other.isOnAddStructurePage, isOnAddStructurePage) ||
                other.isOnAddStructurePage == isOnAddStructurePage) &&
            const DeepCollectionEquality()
                .equals(other._songSections, _songSections));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isOnAddStructurePage,
      const DeepCollectionEquality().hash(_songSections));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongPreferencesControllerStateImplCopyWith<
          _$SongPreferencesControllerStateImpl>
      get copyWith => __$$SongPreferencesControllerStateImplCopyWithImpl<
          _$SongPreferencesControllerStateImpl>(this, _$identity);
}

abstract class _SongPreferencesControllerState
    implements SongPreferencesControllerState {
  const factory _SongPreferencesControllerState(
      {final bool isOnAddStructurePage,
      final List<Section> songSections}) = _$SongPreferencesControllerStateImpl;

  @override
  bool get isOnAddStructurePage;
  @override
  List<Section> get songSections;
  @override
  @JsonKey(ignore: true)
  _$$SongPreferencesControllerStateImplCopyWith<
          _$SongPreferencesControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
