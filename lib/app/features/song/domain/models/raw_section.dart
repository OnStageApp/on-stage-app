import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';

part 'raw_section.freezed.dart';
part 'raw_section.g.dart';

@Freezed()
class RawSection with _$RawSection {
  const factory RawSection({
    StructureItem? structureItem,
    String? content,
  }) = _RawSection;

  factory RawSection.fromJson(Map<String, dynamic> json) =>
      _$RawSectionFromJson(json);
}
