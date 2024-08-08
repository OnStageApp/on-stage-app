import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';

part 'search_controller_state.freezed.dart';

@freezed
class SearchControllerState with _$SearchControllerState {
  const factory SearchControllerState({
    required bool isFocused,
    required String text,
    SearchFilter? genreFilter,
    SearchFilter? artistFilter,
    SearchFilter? themeFilter,
  }) = _SearchControllerState;
}
