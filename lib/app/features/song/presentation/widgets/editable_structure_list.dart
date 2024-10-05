import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class EditableStructureList extends ConsumerWidget {
  const EditableStructureList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final structures = ref
        .watch(songNotifierProvider)
        .sections
        .map((e) => e.structure)
        .toList();

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: structures.length,
        itemBuilder: (context, index) {
          final structureItem = structures[index];
          if (index > 0 && structures[index] == structures[index - 1]) {
            return const SizedBox.shrink();
          }
          final item = structures[index];
          int xTimes = 1;
          while (index + xTimes < structures.length &&
              structures[index + xTimes] == item) {
            xTimes++;
          }
          return AnimatedTile(
            key: ValueKey('${structureItem.shortName}_${structureItem.index}'),
            structureItem: structureItem,
            xTimes: xTimes,
            onTap: () {
              ref
                  .read(songNotifierProvider.notifier)
                  .selectSection(structureItem);
              logger.i('selected ${structureItem.name}');
            },
          );
        },
      ),
    );
  }
}

class AnimatedTile extends StatefulWidget {
  final StructureItem structureItem;
  final int xTimes;
  final VoidCallback onTap;

  const AnimatedTile({
    Key? key,
    required this.structureItem,
    required this.xTimes,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedTileState createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeAnimations();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward();
    widget.onTap();
  }

  void _initializeAnimations() {
    _colorAnimation = ColorTween(
      begin: Color(widget.structureItem.color),
      end: Color(widget.structureItem.color).withOpacity(0.7),
    ).animate(_controller);
    _borderColorAnimation = ColorTween(
      begin: Color(widget.structureItem.color),
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.structureItem != oldWidget.structureItem) {
      _initializeAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            child: Container(
              padding: EdgeInsets.only(right: widget.xTimes > 1 ? 16 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _colorAnimation.value,
              ),
              margin: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    key: ValueKey(
                      '${widget.structureItem.shortName}_${widget.structureItem.index}',
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurfaceVariant,
                      border: Border.all(
                        color: _borderColorAnimation.value!,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.structureItem.shortName,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                  if (widget.xTimes > 1) ...[
                    const SizedBox(width: 4),
                    Text(
                      'x ${widget.xTimes}',
                      style: context.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.shadow,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
