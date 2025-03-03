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
    this.hasNavbar = true,
    super.key,
  });
  final String audioUrl;
  final bool hasNavbar;

  @override
  ConsumerState<StgAudioPlayer> createState() => _StgAudioPlayerState();
}

class _StgAudioPlayerState extends ConsumerState<StgAudioPlayer>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  bool _isInitialized = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Constants
  static const double defaultPlayerWidth = 400;
  static const double largeScreenPlayerWidth = 500;
  static const double playerHeight = 180;
  static const double horizontalPadding = 16;
  static const double navBarHeight = 52;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      setState(() {
        _position = _calculateDefaultOffset(size);
        _isInitialized = true;
      });
      _animationController.forward();
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );
  }

  double get _bottomMargin =>
      (widget.hasNavbar && !context.isLargeScreen) ? navBarHeight : 0;

  Offset _calculateDefaultOffset(Size size) {
    final currentPlayerWidth =
        context.isLargeScreen ? largeScreenPlayerWidth : defaultPlayerWidth;
    return Offset(
      (size.width - currentPlayerWidth) / 2,
      size.height - playerHeight - _bottomMargin,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    final topPosition = context.isLargeScreen
        ? _position.dy
        : _position.dy.clamp(0.0, safeBottomPosition);

    return !_isInitialized
        ? const SizedBox.shrink()
        : Positioned(
            left: context.isLargeScreen ? _position.dx : 0,
            right: context.isLargeScreen ? null : 0,
            top: topPosition,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
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
                                : (_position.dy.clamp(0, safeBottomPosition)
                                    as double),
                          );
                        });
                      },
                      child: Container(
                        width:
                            context.isLargeScreen ? currentPlayerWidth : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: GlassContainer(
                                  child: _buildContent(
                                    context,
                                    state,
                                    audioNotifier,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
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
        _buildHeader(context, state),
        const SizedBox(height: 12),
        const ProgressBarWidget(),
        const SizedBox(height: 4),
        const PlayerControls(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AudioPlayerState state) {
    final fileName =
        ref.watch(audioControllerProvider).currentSongFile?.name ?? 'Undefined';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              fileName,
              style: context.textTheme.titleMedium!
                  .copyWith(color: context.colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (context.isLargeScreen)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: InkWell(
                      onTap: state.status == AudioStatus.loading
                          ? null
                          : _resetPosition,
                      child: Icon(
                        Icons.center_focus_strong,
                        color: context.colorScheme.outline,
                      ),
                    ),
                  );
                },
              ),
            ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _animationController.reverse().then((_) {
          ref.read(audioControllerProvider.notifier).closeFile();
        });
      },
      child: Icon(
        Icons.close,
        color: context.colorScheme.outline,
      ),
    );
  }
}
