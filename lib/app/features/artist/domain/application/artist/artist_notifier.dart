import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artists_state.dart';
import 'package:on_stage_app/app/features/artist/domain/data/artist_repository.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/error_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artist_notifier.g.dart';

@riverpod
class ArtistNotifier extends _$ArtistNotifier {
  late final ArtistRepository _artistRepository;

  @override
  ArtistsState build() {
    final dio = ref.watch(dioProvider);
    _artistRepository = ArtistRepository(dio);
    return const ArtistsState();
  }

  Future<Artist?> addArtist(String name) async {
    state = state.copyWith(error: null);
    try {
      final artist = await _artistRepository.addArtist(
        ArtistRequest(name: name),
      );

      final updatedArtists = [...state.artists, artist];
      state = state.copyWith(
        artists: updatedArtists,
        error: null,
      );
      return artist;
    } on DioException catch (e) {
      String? errorMessage;
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorModel = ApiErrorResponse.fromJson(errorData);

        if (errorModel.errorName == ErrorType.ARTIST_ALREADY_EXISTS) {
          errorMessage = errorModel.errorName?.getDescription('Artist') ??
              'Artist already exists';
        }
      }

      state = state.copyWith(
        error: errorMessage ?? 'There was an error adding the artist',
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        error: 'There was an error adding the artist',
      );
      return null;
    }
  }
}
