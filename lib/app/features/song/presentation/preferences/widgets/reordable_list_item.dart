import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/structure_list_controller.dart';
import 'package:on_stage_app/app/shared/circle_structure_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AnimatedStepper extends StatefulWidget {
  final int value;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final int min;
  final int max;

  const AnimatedStepper({
    super.key,
    required this.value,
    this.onAdd,
    this.onRemove,
    this.min = 1,
    this.max = 10,
  });

  @override
  State<AnimatedStepper> createState() => _AnimatedStepperState();
}

class _AnimatedStepperState extends State<AnimatedStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _increment() {
    if (widget.value < widget.max) {
      _controller.forward().then((_) {
        widget.onAdd?.call();
        _controller.reverse();
      });
    }
  }

  void _decrement() {
    if (widget.value > widget.min) {
      _controller.forward().then((_) {
        widget.onRemove?.call();
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepperButton(
            icon: Icons.remove_rounded,
            onTap: _decrement,
            enabled: widget.value > widget.min,
          ),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              constraints: const BoxConstraints(minWidth: 32),
              alignment: Alignment.center,
              child: Text(
                '×${widget.value}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          _buildStepperButton(
            icon: Icons.add_rounded,
            onTap: _increment,
            enabled: widget.value < widget.max,
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 20,
            color: enabled
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class ReordableListItem extends ConsumerStatefulWidget {
  const ReordableListItem({
    required this.structureItem,
    required this.itemKey,
    required this.multiplier,
    required this.groupIndex,
    this.canSlide = true,
    this.onRemove,
    this.onClone,
    super.key,
  });

  final StructureItem structureItem;
  final int multiplier;
  final int groupIndex;
  final String itemKey;
  final bool canSlide;
  final VoidCallback? onRemove;
  final VoidCallback? onClone;

  @override
  ConsumerState<ReordableListItem> createState() => _ReordableListItemState();
}

class _ReordableListItemState extends ConsumerState<ReordableListItem>
    with SingleTickerProviderStateMixin {
  bool isSliding = false;
  late SlidableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);
  }

  void _setSliding(bool sliding) {
    setState(() {
      isSliding = sliding;
    });
  }

  void _handleAdd() {
    ref
        .read(structureListControllerProvider.notifier)
        .addItemToGroup(widget.groupIndex);
  }

  void _handleRemove() {
    ref
        .read(structureListControllerProvider.notifier)
        .removeItemFromGroup(widget.groupIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Slidable(
        groupTag: 'reordable_list_item',
        key: ValueKey(widget.itemKey),
        enabled: widget.canSlide,
        controller: _controller,
        endActionPane: ActionPane(
          dragDismissible: false,
          motion: const ScrollMotion(),
          children: [
            if (widget.onClone != null)
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await _controller.close();
                    widget.onClone?.call();
                  },
                  child: Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Text(
                      'Clone',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await _controller.close();
                  widget.onRemove?.call();
                },
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Delete',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Builder(
          builder: (context) {
            final controller = Slidable.of(context);
            if (controller != null) {
              controller.actionPaneType.addListener(() {
                if (controller.actionPaneType.value == ActionPaneType.none) {
                  _setSliding(false);
                } else {
                  _setSliding(true);
                }
              });
            }
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: isSliding
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )
                    : BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      color: context.colorScheme.surfaceContainer,
                      size: 20,
                    ),
                  ),
                  StructureCircleWidget(
                    structureItem: widget.structureItem,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.structureItem.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Spacer(),
                  AnimatedStepper(
                    value: widget.multiplier,
                    onAdd: _handleAdd,
                    onRemove: _handleRemove,
                    max: 99,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
