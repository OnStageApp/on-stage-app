import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

part 'song_request.freezed.dart';
part 'song_request.g.dart';

@Freezed()
class SongRequest with _$SongRequest {
  const factory SongRequest({
    String? title,
    List<RawSection>? rawSections,
    List<StructureItem>? structure,
    int? tempo,
    SongKey? originalKey,
    String? artistId,
    ThemeEnum? theme,
    GenreEnum? genre,
  }) = _SongRequest;

  factory SongRequest.fromJson(Map<String, dynamic> json) =>
      _$SongRequestFromJson(json);

  factory SongRequest.fromSongModel(SongModelV2 songModel) {
    return SongRequest(
      title: songModel.title,
      rawSections: songModel.rawSections,
      structure: songModel.structure,
      tempo: songModel.tempo,
      originalKey: songModel.originalKey,
      artistId: songModel.artist?.id,
    );
  }
}
