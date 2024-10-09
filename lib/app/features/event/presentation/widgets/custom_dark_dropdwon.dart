import 'package:flutter/material.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
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
    final buttonText = widget.tabController.index == 0 ? 'Preview' : 'Edit';

    return ContinueButton(
      text: buttonText,
      onPressed: widget.onSwitch,
      isEnabled: true,
      hasShadow: false,
      backgroundColor: context.colorScheme.onSurfaceVariant,
      textColor: context.colorScheme.onSurface,
    );
  }
}
