import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

part 'song_model_v2.freezed.dart';
part 'song_model_v2.g.dart';

@Freezed()
class SongModelV2 with _$SongModelV2 {
  const factory SongModelV2({
    String? id,
    String? title,
    List<RawSection>? rawSections,
    List<StructureItem>? structure,
    int? tempo,
    SongKey? key,
    SongKey? updateKey,
    String? createdAt,
    String? updatedAt,
    Artist? artist,
    String? album,
    int? capo,
  }) = _SongModelV2;

  factory SongModelV2.fromJson(Map<String, dynamic> json) =>
      _$SongModelV2FromJson(json);

  const SongModelV2._();
}
