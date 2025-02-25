import 'package:audio_video_progress_bar/audio_video_progress_bar.dart'; // Import the package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProgressBarWidget extends ConsumerWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final audioNotifier = ref.read(audioControllerProvider.notifier);

    final displayPosition =
        state.isSeeking ? state.seekPosition : state.position;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ProgressBar(
        progress: displayPosition,
        total: state.duration,
        buffered: state.bufferedPosition,
        onSeek: audioNotifier.seek,
        timeLabelLocation: TimeLabelLocation.sides,
        timeLabelType: TimeLabelType.totalTime,
        timeLabelTextStyle: context.textTheme.titleSmall!.copyWith(
          color: context.colorScheme.outline,
        ),
        thumbRadius: 0,
        thumbGlowRadius: 12,
        thumbColor: context.colorScheme.onSurface,
        baseBarColor: context.colorScheme.surfaceContainerHighest,
        progressBarColor: context.colorScheme.onSurface,
        bufferedBarColor: context.colorScheme.outline,
      ),
    );
  }
}
