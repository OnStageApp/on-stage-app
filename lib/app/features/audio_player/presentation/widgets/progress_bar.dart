// Extracted Progress Bar Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProgressBar extends ConsumerWidget {
  const ProgressBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final audioNotifier = ref.read(audioControllerProvider.notifier);
    final positionStr = state.status == AudioStatus.loading
        ? '00:00'
        : audioNotifier.formatDuration(state.position);
    final durationStr = state.status == AudioStatus.loading
        ? '00:00'
        : audioNotifier.formatDuration(state.duration);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            positionStr,
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: const SliderThemeData(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                thumbColor: context.colorScheme.primary,
                value: state.status == AudioStatus.loading
                    ? 0.0
                    : state.position.inMilliseconds.toDouble(),
                max: state.status == AudioStatus.loading
                    ? 1.0
                    : state.duration.inMilliseconds.toDouble(),
                onChanged: state.status == AudioStatus.loading
                    ? null
                    : (value) {
                        final newPosition =
                            Duration(milliseconds: value.toInt());
                        audioNotifier.seek(newPosition);
                      },
              ),
            ),
          ),
          Text(
            durationStr,
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
