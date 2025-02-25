import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

part 'song_overview_model.freezed.dart';
part 'song_overview_model.g.dart';

@Freezed()
class SongOverview with _$SongOverview {
  const factory SongOverview({
    required String id,
    String? title,
    int? tempo,
    SongKey? key,
    Artist? artist,
    @Default(false) bool isFavorite,
    String? teamId,
    String? songMdNotes,
    @Default(false) bool hasFiles,
  }) = _SongOverview;

  factory SongOverview.fromJson(Map<String, dynamic> json) =>
      _$SongOverviewFromJson(json);

  factory SongOverview.fromSong(SongModelV2 song) => SongOverview(
        id: song.id ?? '',
        title: song.title,
        tempo: song.tempo,
        key: song.key,
        artist: song.artist,
        teamId: song.teamId,
        songMdNotes: song.songMdNotes,
      );
}
