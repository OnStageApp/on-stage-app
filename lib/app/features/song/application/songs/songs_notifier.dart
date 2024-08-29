import 'package:on_stage_app/app/features/song/application/songs/songs_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'songs_notifier.g.dart';

@Riverpod(keepAlive: true)
class SongsNotifier extends _$SongsNotifier {
  late final SongRepository _songRepository;

  @override
  SongsState build() {
    final dio = ref.read(dioProvider);
    _songRepository = SongRepository(dio);
    return const SongsState();
  }

  Future<void> getSongs({
    SongFilter? songFilter,
    bool isLoadingWithShimmer = false,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isLoadingWithShimmer: isLoadingWithShimmer,
    );

    final songs = await _songRepository.getSongs(
      songFilter: songFilter ?? const SongFilter(),
    );

    state = state.copyWith(
      isLoading: false,
      isLoadingWithShimmer: false,
      songs: songs,
      filteredSongs: songs,
    );
  }
}
