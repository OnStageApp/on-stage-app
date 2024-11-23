import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
import 'package:on_stage_app/app/features/song/domain/models/tempo_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_notifier.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  SearchState build() {
    return const SearchState(isFocused: false, text: '');
  }

  void setFocus({required bool isFocused}) {
    state = state.copyWith(isFocused: isFocused);
  }

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void clear() {
    state = const SearchState(isFocused: false, text: '');
  }

  void setGenreFilter(GenreEnum? searchFilter) {
    state = state.copyWith(genreFilter: searchFilter);
  }

  void setArtistFilter(Artist? selectedArtist) {
    state = state.copyWith(artistFilter: selectedArtist);
  }

  void setThemeFilter(ThemeEnum? searchFilter) {
    state = state.copyWith(themeFilter: searchFilter);
  }

  void setTeamFilter({required bool teamFilter}) {
    state = state.copyWith(teamFilter: teamFilter);
  }

  void setTempoFilter(int? min, int? max) {
    state = state.copyWith(
      tempoFilter: TempoFilter(min: min, max: max),
    );
  }

  void resetAllFilters() {
    state = state.copyWith(
      genreFilter: null,
      artistFilter: null,
      themeFilter: null,
      tempoFilter: null,
      teamFilter: null,
    );
  }

  void removeFilter(SearchFilter filter) {
    switch (filter.type) {
      case SearchFilterEnum.genre:
        state = state.copyWith(genreFilter: null);

      case SearchFilterEnum.artist:
        state = state.copyWith(artistFilter: null);
      case SearchFilterEnum.theme:
        state = state.copyWith(themeFilter: null);
      case SearchFilterEnum.team:
        state = state.copyWith(teamFilter: null);
      case SearchFilterEnum.tempo:
        state = state.copyWith(tempoFilter: null);
      case SearchFilterEnum.all:
    }
  }

  List<SearchFilter?> getAllFilters() {
    final filters = <SearchFilter?>[];
    if (state.genreFilter != null) {
      filters.add(
        SearchFilter(
          type: SearchFilterEnum.genre,
          value: state.genreFilter!.title,
        ),
      );
    }
    if (state.artistFilter != null) {
      filters.add(
        SearchFilter(
          type: SearchFilterEnum.artist,
          value: state.artistFilter!.name,
        ),
      );
    }
    if (state.themeFilter != null) {
      filters.add(
        SearchFilter(
          type: SearchFilterEnum.theme,
          value: state.themeFilter!.title,
        ),
      );
    }
    if (state.teamFilter != null) {
      filters.add(
        SearchFilter(
          type: SearchFilterEnum.team,
          value: state.teamFilter! ? 'Team Songs' : 'All Songs',
        ),
      );
    }

    if (state.tempoFilter != null) {
      final minValue = state.tempoFilter!.min;
      final maxValue = state.tempoFilter!.max;

      if (minValue == null && maxValue == null) {
        return filters;
      }

      if (minValue == null) {
        filters.add(
          SearchFilter(
            type: SearchFilterEnum.tempo,
            value: 'Up to $maxValue',
          ),
        );
        return filters;
      }
      if (maxValue == null) {
        filters.add(
          SearchFilter(
            type: SearchFilterEnum.tempo,
            value: 'From $minValue',
          ),
        );
        return filters;
      }

      filters.add(
        SearchFilter(
          type: SearchFilterEnum.tempo,
          value: '${state.tempoFilter!.min} - ${state.tempoFilter!.max}',
        ),
      );
    }

    return filters;
  }
}
