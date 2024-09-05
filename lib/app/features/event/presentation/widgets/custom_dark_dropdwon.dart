import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CustomAnimatedTabSwitch extends StatefulWidget {
  final List<String> tabs;
  final TabController tabController;
  final VoidCallback onSwitch;

  const CustomAnimatedTabSwitch({
    required this.tabs,
    required this.tabController,
    required this.onSwitch,
    Key? key,
  }) : super(key: key);

  @override
  _CustomAnimatedTabSwitchState createState() =>
      _CustomAnimatedTabSwitchState();
}

class _CustomAnimatedTabSwitchState extends State<CustomAnimatedTabSwitch> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: context.colorScheme.onSurfaceVariant,
          ),
          child: Text(
            widget.tabs[widget.tabController.index],
            style: context.textTheme.titleSmall!.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: context.colorScheme.onSurfaceVariant,
          ),
          child: InkWell(
            onTap: widget.onSwitch,
            child: Icon(
              Icons.swap_horiz,
              color: context.colorScheme.outline,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
