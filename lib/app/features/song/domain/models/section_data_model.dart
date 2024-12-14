import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/custom_text_widget.dart';

class SectionData {
  SectionData({
    required this.rawSection,
    CustomTextEditingController? controller,
  }) : controller = controller ??
            CustomTextEditingController(text: rawSection.content ?? '');
  final RawSection rawSection;
  final CustomTextEditingController controller;

  SectionData copyWith({
    RawSection? rawSection,
    CustomTextEditingController? controller,
  }) {
    return SectionData(
      rawSection: rawSection ?? this.rawSection,
      controller: controller ?? this.controller,
    );
  }
}
