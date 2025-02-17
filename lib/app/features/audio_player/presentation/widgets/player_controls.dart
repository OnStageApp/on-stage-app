// Extracted PlayerControls Widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final audioNotifier = ref.read(audioControllerProvider.notifier);
    final isLoading = state.status == AudioStatus.loading;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          // Skip to beginning of track.
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(8),
            onPressed:
                isLoading ? null : () => audioNotifier.seek(Duration.zero),
            icon: Icon(
              Icons.fast_rewind_rounded,
              size: 32,
              color: context.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(8),
            onPressed: isLoading ? null : audioNotifier.skipBackward,
            icon: Icon(
              Icons.replay_10_rounded,
              size: 28,
              color: context.colorScheme.onSurface,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(8),
            onPressed: isLoading
                ? null
                : () {
                    if (state.isPlaying) {
                      audioNotifier.pause();
                    } else {
                      audioNotifier.play();
                    }
                  },
            icon: isLoading
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballBeat,
                        colors: [context.colorScheme.onSurface],
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Icon(
                    state.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 42,
                    color: context.colorScheme.onSurface,
                  ),
          ),
          // Forward 10 seconds.
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(8),
            onPressed: isLoading ? null : audioNotifier.skipForward,
            icon: Icon(
              Icons.forward_10_rounded,
              size: 28,
              color: context.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // Skip to end of track.
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(8),
            onPressed:
                isLoading ? null : () => audioNotifier.seek(state.duration),
            icon: Icon(
              Icons.fast_forward_rounded,
              size: 32,
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
