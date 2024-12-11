import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'song_overview_page.freezed.dart';
part 'song_overview_page.g.dart';

@freezed
class SongOverviewPage with _$SongOverviewPage {
  const factory SongOverviewPage({
    required List<SongOverview> songs,
    required bool hasMore,
  }) = _SongOverviewPage;

  factory SongOverviewPage.fromJson(Map<String, dynamic> json) =>
      _$SongOverviewPageFromJson(json);
}
