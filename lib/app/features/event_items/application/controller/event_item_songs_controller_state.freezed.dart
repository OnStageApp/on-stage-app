// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_item_songs_controller_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventItemSongsControllerState {
  List<SongOverview> get songs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventItemSongsControllerStateCopyWith<EventItemSongsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventItemSongsControllerStateCopyWith<$Res> {
  factory $EventItemSongsControllerStateCopyWith(
          EventItemSongsControllerState value,
          $Res Function(EventItemSongsControllerState) then) =
      _$EventItemSongsControllerStateCopyWithImpl<$Res,
          EventItemSongsControllerState>;
  @useResult
  $Res call({List<SongOverview> songs});
}

/// @nodoc
class _$EventItemSongsControllerStateCopyWithImpl<$Res,
        $Val extends EventItemSongsControllerState>
    implements $EventItemSongsControllerStateCopyWith<$Res> {
  _$EventItemSongsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songs = null,
  }) {
    return _then(_value.copyWith(
      songs: null == songs
          ? _value.songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SongOverview>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventItemSongsControllerStateImplCopyWith<$Res>
    implements $EventItemSongsControllerStateCopyWith<$Res> {
  factory _$$EventItemSongsControllerStateImplCopyWith(
          _$EventItemSongsControllerStateImpl value,
          $Res Function(_$EventItemSongsControllerStateImpl) then) =
      __$$EventItemSongsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SongOverview> songs});
}

/// @nodoc
class __$$EventItemSongsControllerStateImplCopyWithImpl<$Res>
    extends _$EventItemSongsControllerStateCopyWithImpl<$Res,
        _$EventItemSongsControllerStateImpl>
    implements _$$EventItemSongsControllerStateImplCopyWith<$Res> {
  __$$EventItemSongsControllerStateImplCopyWithImpl(
      _$EventItemSongsControllerStateImpl _value,
      $Res Function(_$EventItemSongsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? songs = null,
  }) {
    return _then(_$EventItemSongsControllerStateImpl(
      songs: null == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SongOverview>,
    ));
  }
}

/// @nodoc

class _$EventItemSongsControllerStateImpl
    implements _EventItemSongsControllerState {
  const _$EventItemSongsControllerStateImpl(
      {final List<SongOverview> songs = const []})
      : _songs = songs;

  final List<SongOverview> _songs;
  @override
  @JsonKey()
  List<SongOverview> get songs {
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songs);
  }

  @override
  String toString() {
    return 'EventItemSongsControllerState(songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventItemSongsControllerStateImpl &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_songs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventItemSongsControllerStateImplCopyWith<
          _$EventItemSongsControllerStateImpl>
      get copyWith => __$$EventItemSongsControllerStateImplCopyWithImpl<
          _$EventItemSongsControllerStateImpl>(this, _$identity);
}

abstract class _EventItemSongsControllerState
    implements EventItemSongsControllerState {
  const factory _EventItemSongsControllerState(
      {final List<SongOverview> songs}) = _$EventItemSongsControllerStateImpl;

  @override
  List<SongOverview> get songs;
  @override
  @JsonKey(ignore: true)
  _$$EventItemSongsControllerStateImplCopyWith<
          _$EventItemSongsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
