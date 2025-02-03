import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/chord_deletion_input_formatter.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

/// A custom TextEditingController that only customizes text styling.
class CustomTextEditingController extends TextEditingController {
  CustomTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final children = <InlineSpan>[];
    final tagRegex = RegExp(r'(<[^>]+>|\[[^\]]+\])');
    final matches = tagRegex.allMatches(text);
    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      final tagText = text.substring(match.start, match.end);
      if (tagText.startsWith('[') && tagText.endsWith(']')) {
        children.add(
          TextSpan(
            text: tagText,
            style: context.textTheme.titleLarge!
                .copyWith(color: context.colorScheme.primary),
          ),
        );
      } else {
        children.add(
          TextSpan(
            text: tagText,
            style: context.textTheme.titleLarge!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        );
      }
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastMatchEnd)));
    }
    return TextSpan(style: style, children: children);
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.style,
    super.key,
  });

  final CustomTextEditingController controller;
  final FocusNode focusNode;
  final TextStyle style;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        scribbleEnabled: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        focusNode: widget.focusNode,
        enableSuggestions: false,
        autocorrect: false,
        controller: widget.controller,
        maxLines: null,
        minLines: 1,
        inputFormatters: [
          ChordDeletionInputFormatter(),
        ],
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: _getHintText(),
          hintStyle: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        style: context.textTheme.bodyLarge,
      ),
    );
  }

  String _getHintText() => 'eg. [Dm]Burn the ships, cut the [Bb]ties...';
}
