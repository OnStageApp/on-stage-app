import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_structure/song_structure.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/tonality_model.dart';

part 'song_configuration.freezed.dart';
part 'song_configuration.g.dart';

@Freezed()
class SongConfiguration with _$SongConfiguration {
  const factory SongConfiguration({
    String? teamId,
    String? songId,
    SongKey? songKey,
    List<SongStructure>? structure,
  }) = _SongConfiguration;

  factory SongConfiguration.fromJson(Map<String, dynamic> json) =>
      _$SongConfigurationFromJson(json);
}
