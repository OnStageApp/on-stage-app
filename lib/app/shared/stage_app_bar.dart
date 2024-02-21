import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    required this.title,
    this.trailing,
    this.isBackButtonVisible = false,
    super.key,
  });

  final String title;
  final bool isBackButtonVisible;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      padding: defaultAppBarPadding,
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          if (isBackButtonVisible)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
            ),
          Text(
            title,
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
