import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/search/domain/enums/genre_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/search/domain/models/search_filter_model.dart';

part 'search_controller_state.freezed.dart';

@freezed
class SearchControllerState with _$SearchControllerState {
  const factory SearchControllerState({
    required bool isFocused,
    required String text,
    GenreFilterEnum? genreFilter,
    ThemeFilterEnum? themeFilter,
    Artist? artistFilter,
  }) = _SearchControllerState;
}
