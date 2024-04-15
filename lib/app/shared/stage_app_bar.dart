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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: AppBar(
        backgroundColor: background ?? context.colorScheme.background,
        leading: _buildLeading(context),
        leadingWidth: 8,
        centerTitle: false,
        title: titleWidget ??
            Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: isBackButtonVisible ? 16 : 28,
                color: context.colorScheme.shadow,
              ),
              textAlign: TextAlign.start,
            ),
        automaticallyImplyLeading: false,
        actions: [trailing ?? const SizedBox()],
        surfaceTintColor: context.colorScheme.background,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (isBackButtonVisible) {
      return InkWell(
        child: const Icon(
          Icons.arrow_back_ios,
          size: 16,
          color: Color(0xFF828282),
        ),
        onTap: () => context.pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(defaultAppBarHeight);
}
