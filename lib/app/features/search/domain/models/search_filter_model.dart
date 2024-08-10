import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/search/domain/enums/search_filter_enum.dart';

part 'search_filter_model.freezed.dart';

@freezed
class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    required SearchFilterEnum type,
    required String value,
  }) = _SearchFilter;
}
