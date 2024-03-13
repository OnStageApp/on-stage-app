import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:riverpod/riverpod.dart';

final songDetailsProvider =
    FutureProvider.family<SongModel, int>((ref, songId) async {
  return ref.read(songRepositoryProvider.notifier).fetchSong(songId);
});
