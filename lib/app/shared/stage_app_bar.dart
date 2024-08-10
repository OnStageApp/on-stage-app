import 'package:flutter/material.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    required this.title,
    this.titleWidget,
    this.trailing,
    this.isBackButtonVisible = false,
    this.background,
    super.key,
  });

  final String title;
  final Widget? titleWidget;
  final bool isBackButtonVisible;
  final Widget? trailing;

  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isBackButtonVisible ? 16 : 0),
      child: AppBar(
        backgroundColor: background ?? context.colorScheme.surface,
        leading: _buildLeading(context),
        leadingWidth: 8,
        centerTitle: false,
        title: titleWidget ??
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: isBackButtonVisible ? 16 : 28,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
        automaticallyImplyLeading: false,
        actions: [trailing ?? const SizedBox()],
        surfaceTintColor: context.colorScheme.surface,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (isBackButtonVisible) {
      return InkWell(
        child: Icon(
          Icons.arrow_back_ios,
          size: 16,
          color: context.colorScheme.outline,
        ),
        onTap: () => context.pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);
}
