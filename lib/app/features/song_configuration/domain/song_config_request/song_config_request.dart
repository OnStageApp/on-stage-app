import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';

part 'song_config_request.freezed.dart';
part 'song_config_request.g.dart';

@Freezed()
class SongConfigRequest with _$SongConfigRequest {
  const factory SongConfigRequest({
    String? teamId,
    String? songId,
    SongKey? key,
    bool? isCustom,
    List<StructureItem>? structure,
    String? songMdNotes,
  }) = _SongConfigRequest;

  factory SongConfigRequest.fromJson(Map<String, dynamic> json) =>
      _$SongConfigRequestFromJson(json);
}
