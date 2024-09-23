import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({this.title, super.key, this.subtitle});
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title ?? 'Plan together.\nWorship together.',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontWeight: FontWeight.w700,
              height: 1.2,
              fontSize: 32,
              color: context.colorScheme.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Text(
                subtitle!,
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.colorScheme.onSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
