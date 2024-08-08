import 'package:on_stage_app/app/features/search/application/search_controller_state.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  SearchControllerState build() {
    return const SearchControllerState(isFocused: false, text: '');
  }

  void setFocus({required bool isFocused}) {
    state = state.copyWith(isFocused: isFocused);
  }

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void clear() {
    state = const SearchControllerState(isFocused: false, text: '');
  }

  void setGenreFilter(SearchFilter? searchFilter) {
    state = state.copyWith(genreFilter: searchFilter);
  }

  void setArtistFilter(SearchFilter? searchFilter) {
    state = state.copyWith(artistFilter: searchFilter);
  }

  void setThemeFilter(SearchFilter? searchFilter) {
    state = state.copyWith(themeFilter: searchFilter);
  }

  List<SearchFilter?> getAllFilters() {
    final filters = <SearchFilter?>[];
    if (state.genreFilter != null) {
      filters.add(state.genreFilter);
    }
    if (state.artistFilter != null) {
      filters.add(state.artistFilter);
    }
    if (state.themeFilter != null) {
      filters.add(state.themeFilter);
    }
    return filters;
  }
}
