import 'package:freezed_annotation/freezed_annotation.dart';

part 'tempo_filter.freezed.dart';
part 'tempo_filter.g.dart';

@Freezed()
class TempoFilter with _$TempoFilter {
  const factory TempoFilter({
    int? min,
    int? max,
  }) = _TempoFilter;

  factory TempoFilter.fromJson(Map<String, dynamic> json) =>
      _$TempoFilterFromJson(json);
}
