// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_controller_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchControllerState {
  bool get isFocused => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  GenreFilterEnum? get genreFilter => throw _privateConstructorUsedError;
  ThemeFilterEnum? get themeFilter => throw _privateConstructorUsedError;
  Artist? get artistFilter => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchControllerStateCopyWith<SearchControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchControllerStateCopyWith<$Res> {
  factory $SearchControllerStateCopyWith(SearchControllerState value,
          $Res Function(SearchControllerState) then) =
      _$SearchControllerStateCopyWithImpl<$Res, SearchControllerState>;
  @useResult
  $Res call(
      {bool isFocused,
      String text,
      GenreFilterEnum? genreFilter,
      ThemeFilterEnum? themeFilter,
      Artist? artistFilter});

  $ArtistCopyWith<$Res>? get artistFilter;
}

/// @nodoc
class _$SearchControllerStateCopyWithImpl<$Res,
        $Val extends SearchControllerState>
    implements $SearchControllerStateCopyWith<$Res> {
  _$SearchControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFocused = null,
    Object? text = null,
    Object? genreFilter = freezed,
    Object? themeFilter = freezed,
    Object? artistFilter = freezed,
  }) {
    return _then(_value.copyWith(
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      genreFilter: freezed == genreFilter
          ? _value.genreFilter
          : genreFilter // ignore: cast_nullable_to_non_nullable
              as GenreFilterEnum?,
      themeFilter: freezed == themeFilter
          ? _value.themeFilter
          : themeFilter // ignore: cast_nullable_to_non_nullable
              as ThemeFilterEnum?,
      artistFilter: freezed == artistFilter
          ? _value.artistFilter
          : artistFilter // ignore: cast_nullable_to_non_nullable
              as Artist?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ArtistCopyWith<$Res>? get artistFilter {
    if (_value.artistFilter == null) {
      return null;
    }

    return $ArtistCopyWith<$Res>(_value.artistFilter!, (value) {
      return _then(_value.copyWith(artistFilter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchControllerStateImplCopyWith<$Res>
    implements $SearchControllerStateCopyWith<$Res> {
  factory _$$SearchControllerStateImplCopyWith(
          _$SearchControllerStateImpl value,
          $Res Function(_$SearchControllerStateImpl) then) =
      __$$SearchControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isFocused,
      String text,
      GenreFilterEnum? genreFilter,
      ThemeFilterEnum? themeFilter,
      Artist? artistFilter});

  @override
  $ArtistCopyWith<$Res>? get artistFilter;
}

/// @nodoc
class __$$SearchControllerStateImplCopyWithImpl<$Res>
    extends _$SearchControllerStateCopyWithImpl<$Res,
        _$SearchControllerStateImpl>
    implements _$$SearchControllerStateImplCopyWith<$Res> {
  __$$SearchControllerStateImplCopyWithImpl(_$SearchControllerStateImpl _value,
      $Res Function(_$SearchControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFocused = null,
    Object? text = null,
    Object? genreFilter = freezed,
    Object? themeFilter = freezed,
    Object? artistFilter = freezed,
  }) {
    return _then(_$SearchControllerStateImpl(
      isFocused: null == isFocused
          ? _value.isFocused
          : isFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      genreFilter: freezed == genreFilter
          ? _value.genreFilter
          : genreFilter // ignore: cast_nullable_to_non_nullable
              as GenreFilterEnum?,
      themeFilter: freezed == themeFilter
          ? _value.themeFilter
          : themeFilter // ignore: cast_nullable_to_non_nullable
              as ThemeFilterEnum?,
      artistFilter: freezed == artistFilter
          ? _value.artistFilter
          : artistFilter // ignore: cast_nullable_to_non_nullable
              as Artist?,
    ));
  }
}

/// @nodoc

class _$SearchControllerStateImpl implements _SearchControllerState {
  const _$SearchControllerStateImpl(
      {required this.isFocused,
      required this.text,
      this.genreFilter,
      this.themeFilter,
      this.artistFilter});

  @override
  final bool isFocused;
  @override
  final String text;
  @override
  final GenreFilterEnum? genreFilter;
  @override
  final ThemeFilterEnum? themeFilter;
  @override
  final Artist? artistFilter;

  @override
  String toString() {
    return 'SearchControllerState(isFocused: $isFocused, text: $text, genreFilter: $genreFilter, themeFilter: $themeFilter, artistFilter: $artistFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchControllerStateImpl &&
            (identical(other.isFocused, isFocused) ||
                other.isFocused == isFocused) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.genreFilter, genreFilter) ||
                other.genreFilter == genreFilter) &&
            (identical(other.themeFilter, themeFilter) ||
                other.themeFilter == themeFilter) &&
            (identical(other.artistFilter, artistFilter) ||
                other.artistFilter == artistFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isFocused, text, genreFilter, themeFilter, artistFilter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchControllerStateImplCopyWith<_$SearchControllerStateImpl>
      get copyWith => __$$SearchControllerStateImplCopyWithImpl<
          _$SearchControllerStateImpl>(this, _$identity);
}

abstract class _SearchControllerState implements SearchControllerState {
  const factory _SearchControllerState(
      {required final bool isFocused,
      required final String text,
      final GenreFilterEnum? genreFilter,
      final ThemeFilterEnum? themeFilter,
      final Artist? artistFilter}) = _$SearchControllerStateImpl;

  @override
  bool get isFocused;
  @override
  String get text;
  @override
  GenreFilterEnum? get genreFilter;
  @override
  ThemeFilterEnum? get themeFilter;
  @override
  Artist? get artistFilter;
  @override
  @JsonKey(ignore: true)
  _$$SearchControllerStateImplCopyWith<_$SearchControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
