import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';

part 'song_overview_model.freezed.dart';
part 'song_overview_model.g.dart';

@Freezed()
class SongOverview with _$SongOverview {
  const factory SongOverview({
    required String id,
    String? title,
    int? tempo,
    String? key,
    Artist? artist,
  }) = _SongOverview;

  factory SongOverview.fromJson(Map<String, dynamic> json) =>
      _$SongOverviewFromJson(json);
}
