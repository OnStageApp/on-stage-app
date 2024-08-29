import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Load More',
        style: context.textTheme.bodyLarge!.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
