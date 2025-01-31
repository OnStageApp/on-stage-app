import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
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

  void setLibraryFilter({required bool isLibrary}) {
    state = state.copyWith(isLibrary: isLibrary);
  }

  void resetAllFilters() {
    state = state.copyWith(
      artistFilter: null,
      themeFilter: null,
      tempoFilter: null,
      teamFilter: null,
    );
  }

  void removeFilter(SearchFilter filter) {
    switch (filter.type) {
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
}
