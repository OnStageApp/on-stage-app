import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Plan together.\nWorship together.',
        style: TextStyle(
          fontFamily: 'DMSans',
          fontWeight: FontWeight.w700,
          height: 1.2,
          fontSize: 32,
          color: context.colorScheme.onSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
