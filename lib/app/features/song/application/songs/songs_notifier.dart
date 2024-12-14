import 'dart:async';

import 'package:on_stage_app/app/features/song/application/songs/songs_state.dart';
import 'package:on_stage_app/app/features/song/data/song_repository.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_filter/song_filter.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/error_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'songs_notifier.g.dart';

@Riverpod()
class SongsNotifier extends _$SongsNotifier {
  SongRepository? _songRepository;
  static const int _pageSize = 25;

  SongRepository get songRepository {
    _songRepository ??= SongRepository(ref.watch(dioProvider));
    return _songRepository!;
  }

  static const String _userId = '9zNhTEXqVXdbXZoUczUtWK3OJq63';

  @override
  SongsState build() {
    final dio = ref.watch(dioProvider);
    _songRepository = SongRepository(dio);
    return const SongsState();
  }

  Future<void> _getSongsCount() async {
    final songsCount = await songRepository.getSongsCount();
    state = state.copyWith(songsCount: songsCount);
  }

  Future<void> getSongs({
    SongFilter? songFilter,
    bool isLoadingWithShimmer = false,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isLoadingWithShimmer: isLoadingWithShimmer,
      error: null,
    );

    unawaited(_getSongsCount());
    try {
      await Future.wait([
        _fetchSongs(songFilter),
        _fetchFavoriteSongs(),
      ]);
    } catch (error) {
      final appError = ErrorHandler.handleError(error, 'Error fetching songs');
      state = state.copyWith(error: appError.message);
    } finally {
      state = state.copyWith(
        isLoading: false,
        isLoadingWithShimmer: false,
      );
    }
  }

  Future<void> loadMoreSongs(
    SongFilter? songFilter,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final songsPage = await songRepository.getSongsWithPagination(
        songFilter: songFilter ?? const SongFilter(),
        limit: _pageSize,
        offset: state.songs.length,
      );

      final hasMore = songsPage.songs.length >= _pageSize;

      final allSongs = [...state.songs, ...songsPage.songs];

      _updateSongs(allSongs);

      state = state.copyWith(hasMore: hasMore);
    } catch (error) {
      final appError = ErrorHandler.handleError(error, 'Error fetching songs');
      state = state.copyWith(error: appError.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addToFavorite(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _updateSongFavoriteStatus(id, true);
      await songRepository.saveFavoriteSong(
        songId: id,
        userId: _userId,
      );
    } catch (error) {
      final appError =
          ErrorHandler.handleError(error, 'Error adding song to favorites');
      state = state.copyWith(error: appError.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> removeFavorite(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _updateSongFavoriteStatus(id, false);
      await songRepository.removeSavedSong(
        songId: id,
        userId: _userId,
      );
    } catch (error) {
      final appError =
          ErrorHandler.handleError(error, 'Error removing song from favorites');
      state = state.copyWith(error: appError.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getSavedSongs() async {
    state = state.copyWith(
      isLoading: true,
      isLoadingWithShimmer: true,
      error: null,
    );
    try {
      final savedSongs = await songRepository.getSavedSongs();
      _updateSavedSongs(savedSongs);
    } catch (error) {
      final appError =
          ErrorHandler.handleError(error, 'Error fetching favorite songs');
      state = state.copyWith(error: appError.message);
    } finally {
      state = state.copyWith(isLoading: false, isLoadingWithShimmer: false);
    }
  }

  Future<void> _fetchSongs(SongFilter? songFilter) async {
    try {
      final songsPage = await songRepository.getSongsWithPagination(
        songFilter: songFilter ?? const SongFilter(),
        limit: _pageSize,
        offset: 0,
      );

      final hasMore = songsPage.songs.length >= _pageSize;

      _updateSongs(songsPage.songs);

      state = state.copyWith(hasMore: hasMore);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchFavoriteSongs() async {
    try {
      final favoriteSongs = await songRepository.getSavedSongs();
      _updateSavedSongs(favoriteSongs);
    } catch (e) {
      rethrow; // Let the parent method handle this error
    }
  }

  void _updateSongs(List<SongOverview> songs) {
    final updatedSongs = songs.map((song) {
      return song.copyWith(
        isFavorite: state.savedSongs.any((favSong) => favSong.id == song.id),
      );
    }).toList();

    state = state.copyWith(
      songs: updatedSongs,
      filteredSongs: updatedSongs,
    );
  }

  void _updateSavedSongs(List<SongOverview> savedSongs) {
    state = state.copyWith(savedSongs: savedSongs);

    final updatedSongs = state.songs.map((song) {
      return song.copyWith(
        isFavorite: savedSongs.any((favSong) => favSong.id == song.id),
      );
    }).toList();

    state = state.copyWith(
      songs: updatedSongs,
      filteredSongs: updatedSongs,
      savedSongs: updatedSongs.where((song) => song.isFavorite).toList(),
    );
  }

  void _updateSongFavoriteStatus(String id, bool isFavorite) {
    final updatedSongs = state.songs.map((song) {
      return song.id == id ? song.copyWith(isFavorite: isFavorite) : song;
    }).toList();

    final updatedSavedSongs = isFavorite
        ? [
            ...state.savedSongs,
            updatedSongs.firstWhere((song) => song.id == id),
          ]
        : state.savedSongs.where((song) => song.id != id).toList();

    state = state.copyWith(
      songs: updatedSongs,
      filteredSongs: updatedSongs,
      savedSongs: updatedSavedSongs,
    );
  }
}
