import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/song_details_widget.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class EditableStructureList extends ConsumerWidget {
  const EditableStructureList({this.isEditing = false, super.key});

  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sections = <Section>[];

    sections = ref.watch(songNotifierProvider).sections;

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final structure = sections[index].structure;
          final count = sections[index].count;
          return AnimatedTile(
            key: ValueKey('${structure.shortName}_'
                '${structure.index}'),
            structureItem: structure,
            index: index,
            xTimes: count,
            onTap: () {
              ref.read(songNotifierProvider.notifier).selectSection(index);
              logger.i('selected ${structure.name}');
            },
          );
        },
      ),
    );
  }
}

class AnimatedTile extends ConsumerStatefulWidget {
  const AnimatedTile({
    required this.structureItem,
    required this.xTimes,
    required this.onTap,
    required this.index,
    super.key,
  });

  final StructureItem structureItem;
  final int xTimes;
  final VoidCallback onTap;
  final int index;

  @override
  _AnimatedTileState createState() => _AnimatedTileState();
}

class _AnimatedTileState extends ConsumerState<AnimatedTile>
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
                      '${widget.structureItem.shortName}_'
                      '${widget.structureItem.index}',
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurfaceVariant,
                      border: Border.all(
                        color: ref
                                    .watch(songNotifierProvider)
                                    .selectedStructureIndex ==
                                widget.index
                            ? Colors.white
                            : _borderColorAnimation.value!,
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
