import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/application/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  @override
  SearchState build() {
    return SearchState(isFocused: false, text: '');
  }

  void setFocus({required bool isFocused}) {
    state = state.copyWith(isFocused: isFocused);
  }

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void clear() {
    state = SearchState(isFocused: false, text: '');
  }
}
