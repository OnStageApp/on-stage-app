import 'package:on_stage_app/app/features/artist/domain/application/artists_state.dart';
import 'package:on_stage_app/app/features/artist/domain/data/artist_repository.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artist_notifier.g.dart';

@riverpod
class ArtistNotifier extends _$ArtistNotifier {
  late final ArtistRepository _artistRepository;

  @override
  ArtistsState build() {
    final dio = ref.read(dioProvider);
    _artistRepository = ArtistRepository(dio);
    return const ArtistsState();
  }

  Future<void> getArtists() async {
    state = state.copyWith(isLoading: true);
    final artists = await _artistRepository.getArtists();
    state = state.copyWith(
      isLoading: false,
      artists: artists,
      filteredArtists: artists,
    );
  }
}
