// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_structure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongStructure _$SongStructureFromJson(Map<String, dynamic> json) {
  return _SongStructure.fromJson(json);
}

/// @nodoc
mixin _$SongStructure {
  StructureItem get item => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SongStructureCopyWith<SongStructure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongStructureCopyWith<$Res> {
  factory $SongStructureCopyWith(
          SongStructure value, $Res Function(SongStructure) then) =
      _$SongStructureCopyWithImpl<$Res, SongStructure>;
  @useResult
  $Res call({StructureItem item, int id});
}

/// @nodoc
class _$SongStructureCopyWithImpl<$Res, $Val extends SongStructure>
    implements $SongStructureCopyWith<$Res> {
  _$SongStructureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as StructureItem,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongStructureImplCopyWith<$Res>
    implements $SongStructureCopyWith<$Res> {
  factory _$$SongStructureImplCopyWith(
          _$SongStructureImpl value, $Res Function(_$SongStructureImpl) then) =
      __$$SongStructureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({StructureItem item, int id});
}

/// @nodoc
class __$$SongStructureImplCopyWithImpl<$Res>
    extends _$SongStructureCopyWithImpl<$Res, _$SongStructureImpl>
    implements _$$SongStructureImplCopyWith<$Res> {
  __$$SongStructureImplCopyWithImpl(
      _$SongStructureImpl _value, $Res Function(_$SongStructureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? id = null,
  }) {
    return _then(_$SongStructureImpl(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as StructureItem,
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongStructureImpl implements _SongStructure {
  const _$SongStructureImpl(this.item, this.id);

  factory _$SongStructureImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongStructureImplFromJson(json);

  @override
  final StructureItem item;
  @override
  final int id;

  @override
  String toString() {
    return 'SongStructure(item: $item, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongStructureImpl &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, item, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SongStructureImplCopyWith<_$SongStructureImpl> get copyWith =>
      __$$SongStructureImplCopyWithImpl<_$SongStructureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongStructureImplToJson(
      this,
    );
  }
}

abstract class _SongStructure implements SongStructure {
  const factory _SongStructure(final StructureItem item, final int id) =
      _$SongStructureImpl;

  factory _SongStructure.fromJson(Map<String, dynamic> json) =
      _$SongStructureImpl.fromJson;

  @override
  StructureItem get item;
  @override
  int get id;
  @override
  @JsonKey(ignore: true)
  _$$SongStructureImplCopyWith<_$SongStructureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
