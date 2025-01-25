import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/custom_text_widget.dart';

class SectionData {
  SectionData({
    required this.rawSection,
    required this.focusNode,
    CustomTextEditingController? controller,
  }) : controller = controller ??
            CustomTextEditingController(text: rawSection.content ?? '');
  final RawSection rawSection;
  final FocusNode focusNode;
  final CustomTextEditingController controller;

  SectionData copyWith({
    RawSection? rawSection,
    CustomTextEditingController? controller,
  }) {
    return SectionData(
      rawSection: rawSection ?? this.rawSection,
      focusNode: focusNode,
      controller: controller ?? this.controller,
    );
  }
}
