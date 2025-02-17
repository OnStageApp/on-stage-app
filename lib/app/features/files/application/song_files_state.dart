import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';

part 'song_files_state.freezed.dart';

@freezed
class SongFilesState with _$SongFilesState {
  const factory SongFilesState({
    @Default([]) List<SongFile> songFiles,
    @Default(false) bool isLoading,
    SongFile? currentPlayingFile,
    Object? error,
  }) = _SongFilesState;
}
