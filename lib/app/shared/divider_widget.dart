import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      thickness: 1,
      height: 0,
    );
  }
}
