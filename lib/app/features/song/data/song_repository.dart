import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_repository.g.dart';

@riverpod
class SongRepository extends _$SongRepository {
  @override
  FutureOr build() {}

  Future<List<SongModel>> fetchSongs() async {
    final songs = await Future.delayed(
      const Duration(seconds: 1),
      () => SongDummy.songs,
    );
    return songs;
  }
}
