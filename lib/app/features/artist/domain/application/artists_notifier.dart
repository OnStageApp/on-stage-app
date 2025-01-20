import 'package:on_stage_app/app/features/artist/domain/application/artists_state.dart';
import 'package:on_stage_app/app/features/artist/domain/data/artist_repository.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_filter.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artists_notifier.g.dart';

@riverpod
class ArtistsNotifier extends _$ArtistsNotifier {
  static const int _pageSize = 25;
  late final ArtistRepository _artistRepository;

  @override
  ArtistsState build() {
    final dio = ref.watch(dioProvider);
    _artistRepository = ArtistRepository(dio);
    return const ArtistsState();
  }

  Future<void> getArtists({ArtistFilter? search}) async {
    try {
      final artistResponse = await _artistRepository.getArtists(
        filter: search,
        offset: 0,
      );

      logger.i('Artists: ${artistResponse.artists.length}');

      state = state.copyWith(
        isLoading: false,
        artists: artistResponse.artists,
        hasMore: artistResponse.hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> getMoreArtists({ArtistFilter? search}) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final artistResponse = await _artistRepository.getArtists(
        filter: search,
        offset: state.artists.length,
      );

      logger.i('More Artists: ${artistResponse.artists.length}');

      state = state.copyWith(
        isLoading: false,
        artists: [...state.artists, ...artistResponse.artists],
        hasMore: artistResponse.hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void resetArtists() {
    state = const ArtistsState();
  }
}
