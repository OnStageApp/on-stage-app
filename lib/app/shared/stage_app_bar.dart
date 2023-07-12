import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    this.trailing,
    super.key,
  });

  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      padding: defaultAppBarPadding,
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Text(
            'Songs',
            style: context.textTheme.headlineMedium,
          ),
          const Expanded(child: SizedBox()),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);
}
