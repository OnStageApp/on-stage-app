import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.surfaceVariant,
      thickness: 1,
      height: 0,
    );
  }
}
