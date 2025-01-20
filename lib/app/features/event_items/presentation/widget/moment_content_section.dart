import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MomentContentSection extends StatelessWidget {
  const MomentContentSection({
    required this.titleController,
    required this.descriptionController,
    required this.descriptionFocusNode,
    required this.isEditingEnabled,
    required this.onContentChanged,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final FocusNode descriptionFocusNode;
  final bool isEditingEnabled;
  final void Function(String, String) onContentChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            style: context.textTheme.headlineLarge,
            enabled: isEditingEnabled,
            onChanged: (value) =>
                onContentChanged(value, descriptionController.text),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            focusNode: descriptionFocusNode,
            enabled: isEditingEnabled,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
            minLines: 5,
            maxLines: 10,
            onChanged: (value) => onContentChanged(titleController.text, value),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
