import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';

part 'song_structure.freezed.dart';
part 'song_structure.g.dart';

@Freezed()
class SongStructure with _$SongStructure {
  const factory SongStructure(
    StructureItem item,
    int id,
  ) = _SongStructure;

  factory SongStructure.fromJson(Map<String, dynamic> json) =>
      _$SongStructureFromJson(json);
}
