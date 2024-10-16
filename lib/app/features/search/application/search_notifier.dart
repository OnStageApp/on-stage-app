import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
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

  void setGenreFilter(GenreFilterEnum? searchFilter) {
    state = state.copyWith(genreFilter: searchFilter);
  }

  void setArtistFilter(Artist? selectedArtist) {
    state = state.copyWith(artistFilter: selectedArtist);
  }

  void setThemeFilter(ThemeFilterEnum? searchFilter) {
    state = state.copyWith(themeFilter: searchFilter);
  }

  void setTeamFilter({required bool teamFilter}) {
    state = state.copyWith(teamFilter: teamFilter);
  }

  void resetAllFilters() {
    state = state.copyWith(
      genreFilter: null,
      artistFilter: null,
      themeFilter: null,
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

      case SearchFilterEnum.all:
      case SearchFilterEnum.bpm:
    }
  }

  List<SearchFilter?> getAllFilters() {
    final filters = <SearchFilter?>[];
    if (state.genreFilter != null) {
      filters.add(
        SearchFilter(
          type: SearchFilterEnum.genre,
          value: state.genreFilter!.value,
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
          value: state.themeFilter!.value,
        ),
      );
    }
    return filters;
  }
}
