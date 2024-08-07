import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class SavedSongsTile extends StatelessWidget {
  const SavedSongsTile({
    required this.title,
    required this.hour,
    required this.location,
    super.key,
  });

  final String title;
  final String hour;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Assets.icons.heartFilled.svg(
                color: context.colorScheme.outline,
              ),
              const SizedBox(width: Insets.small),
              Text(
                'Saved songs',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '6',
                style: context.textTheme.headlineLarge,
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Assets.icons.arrowForward.svg(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
