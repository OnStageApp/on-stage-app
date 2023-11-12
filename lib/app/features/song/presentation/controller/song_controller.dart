import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_controller.g.dart';

@riverpod
class SongController extends _$SongController {
  SongController(this.repository);
  @override
  FutureOr build() {}
  final SongRepository repository;

  Future<Future<List<Song>>> getSongs(String id) async {
    return repository.fetchSongs();
  }
}
