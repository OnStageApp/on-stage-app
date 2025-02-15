import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_notifier.dart';
import 'package:on_stage_app/app/features/audio_player/application/audio_player_state.dart';
import 'package:on_stage_app/app/features/audio_player/presentation/widgets/glass_container.dart';
import 'package:on_stage_app/app/features/audio_player/presentation/widgets/player_controls.dart';
import 'package:on_stage_app/app/features/audio_player/presentation/widgets/progress_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StgAudioPlayer extends ConsumerStatefulWidget {
  const StgAudioPlayer({
    required this.audioUrl,
    this.hasNavbar = true, // default to true
    super.key,
  });
  final String audioUrl;
  final bool hasNavbar;

  @override
  ConsumerState<StgAudioPlayer> createState() => _StgAudioPlayerState();
}

class _StgAudioPlayerState extends ConsumerState<StgAudioPlayer> {
  Offset _position = Offset.zero;
  bool _isInitialized = false; // Track initialization

  // Constants (configurable if needed)
  static const double defaultPlayerWidth = 400;
  static const double largeScreenPlayerWidth = 500;
  static const double playerHeight = 180;
  static const double horizontalPadding = 16;
  // Define navbar height (if present)
  static const double navBarHeight = 52;

  /// Calculates the bottom margin based on navbar presence.
  double get _bottomMargin =>
      (widget.hasNavbar && !context.isLargeScreen) ? navBarHeight : 0;

  /// Computes the default offset for the player.
  Offset _calculateDefaultOffset(Size size) {
    final currentPlayerWidth =
        context.isLargeScreen ? largeScreenPlayerWidth : defaultPlayerWidth;
    return Offset(
      (size.width - currentPlayerWidth) / 2,
      size.height - playerHeight - _bottomMargin,
    );
  }

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to get the size info.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      setState(() {
        _position = _calculateDefaultOffset(size);
        _isInitialized = true;
      });
      ref.read(audioControllerProvider.notifier).loadAudio(widget.audioUrl);
    });
  }

  @override
  void didUpdateWidget(covariant StgAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasNavbar != widget.hasNavbar) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _position = _calculateDefaultOffset(size);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioControllerProvider);
    final audioNotifier = ref.read(audioControllerProvider.notifier);
    final size = MediaQuery.of(context).size;
    final currentPlayerWidth =
        context.isLargeScreen ? largeScreenPlayerWidth : defaultPlayerWidth;
    final safeBottomPosition = size.height - _bottomMargin;

    // Clamp vertical movement on small screens.
    final topPosition = context.isLargeScreen
        ? _position.dy
        : _position.dy.clamp(0.0, safeBottomPosition);

    return !_isInitialized
        ? const SizedBox.shrink()
        : AnimatedPositioned(
            duration: context.isLargeScreen
                ? Duration.zero
                : const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: context.isLargeScreen ? _position.dx : 0,
            right: context.isLargeScreen ? null : 0,
            top: topPosition,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (!context.isLargeScreen) return;
                setState(() {
                  _position += details.delta;
                  _position = Offset(
                    _position.dx
                        .clamp(0, size.width - currentPlayerWidth)
                        .toDouble(),
                    context.isLargeScreen
                        ? _position.dy
                        : (_position.dy.clamp(0, safeBottomPosition) as double),
                  );
                });
              },
              child: Container(
                width: context.isLargeScreen ? currentPlayerWidth : null,
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: GlassContainer(
                  child: _buildContent(context, state, audioNotifier),
                ),
              ),
            ),
          );
  }

  void _resetPosition() {
    final size = MediaQuery.of(context).size;
    setState(() {
      _position = _calculateDefaultOffset(size);
    });
  }

  Widget _buildContent(
    BuildContext context,
    AudioPlayerState state,
    AudioController audioNotifier,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                'laud-numele-tenor.wav',
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
              const Spacer(),
              if (context.isLargeScreen)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: state.status == AudioStatus.loading
                        ? null
                        : _resetPosition,
                    child: Icon(
                      Icons.center_focus_strong,
                      color: context.colorScheme.outline,
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  // Optionally implement a stop or close action.
                },
                child: Icon(
                  Icons.close,
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ProgressBar(),
        const SizedBox(height: 4),
        const PlayerControls(),
      ],
    );
  }
}
