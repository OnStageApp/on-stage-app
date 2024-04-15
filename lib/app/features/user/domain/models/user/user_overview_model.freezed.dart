// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserOverview _$UserOverviewFromJson(Map<String, dynamic> json) {
  return _UserOverview.fromJson(json);
}

/// @nodoc
mixin _$UserOverview {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserOverviewCopyWith<UserOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserOverviewCopyWith<$Res> {
  factory $UserOverviewCopyWith(
          UserOverview value, $Res Function(UserOverview) then) =
      _$UserOverviewCopyWithImpl<$Res, UserOverview>;
  @useResult
  $Res call({String? id, String? name, String? profileImage});
}

/// @nodoc
class _$UserOverviewCopyWithImpl<$Res, $Val extends UserOverview>
    implements $UserOverviewCopyWith<$Res> {
  _$UserOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? profileImage = freezed,
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
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserOverviewImplCopyWith<$Res>
    implements $UserOverviewCopyWith<$Res> {
  factory _$$UserOverviewImplCopyWith(
          _$UserOverviewImpl value, $Res Function(_$UserOverviewImpl) then) =
      __$$UserOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, String? profileImage});
}

/// @nodoc
class __$$UserOverviewImplCopyWithImpl<$Res>
    extends _$UserOverviewCopyWithImpl<$Res, _$UserOverviewImpl>
    implements _$$UserOverviewImplCopyWith<$Res> {
  __$$UserOverviewImplCopyWithImpl(
      _$UserOverviewImpl _value, $Res Function(_$UserOverviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? profileImage = freezed,
  }) {
    return _then(_$UserOverviewImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserOverviewImpl implements _UserOverview {
  const _$UserOverviewImpl({this.id, this.name, this.profileImage});

  factory _$UserOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserOverviewImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'UserOverview(id: $id, name: $name, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserOverviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserOverviewImplCopyWith<_$UserOverviewImpl> get copyWith =>
      __$$UserOverviewImplCopyWithImpl<_$UserOverviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserOverviewImplToJson(
      this,
    );
  }
}

abstract class _UserOverview implements UserOverview {
  const factory _UserOverview(
      {final String? id,
      final String? name,
      final String? profileImage}) = _$UserOverviewImpl;

  factory _UserOverview.fromJson(Map<String, dynamic> json) =
      _$UserOverviewImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get profileImage;
  @override
  @JsonKey(ignore: true)
  _$$UserOverviewImplCopyWith<_$UserOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
