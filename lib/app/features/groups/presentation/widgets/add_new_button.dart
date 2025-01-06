import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddNewButton extends StatelessWidget {
  const AddNewButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.plus,
            color: context.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            'New',
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
